defmodule Example.Test.Client do
    require Logger
    require Record

    Record.defrecordp(:client,
        pid: nil,
        mref: nil,
        sref: nil,
        tls: nil,
        port: nil,
        headers: nil,
        protocol: nil,
        ws_state: nil,
        data: [])

    def start do
        port = Application.get_env(:example, :service_port, 8080)
        tls = Application.get_env(:example, :tls, false)

        {:ok, pid} = open(port, tls)

        :gun.ws_upgrade(pid, '/ws')

        state = client(pid: pid, port: port, tls: tls)
        case start(state) do
            {:ok, new_state} ->
                start(new_state)
            error ->
                error
        end
    end

    defp start(state = client(pid: pid)) do
            receive do
                {:gun_up, ^pid, protocol} ->
                    Logger.debug("[#{__MODULE__}] :gun_up")
                    {:ok, client(state, protocol: protocol)}
                {:gun_ws_upgrade, ^pid, :ok, headers} ->
                    Logger.debug("[#{__MODULE__}] :gun_ws_upgrade")
                    {:ok, client(pid: pid, headers: headers, ws_state: :ready)}
                unexpected ->
                    {:error, unexpected: unexpected}
            after
                5_000 ->
                    {:error, :start_timeout}
            end
    end

    defp open(port, false) do
        :gun.open('localhost', port)
    end
    defp open(port, true) do
        :gun.open('localhost', port, %{:transport => :ssl, :transport_opts => [verify: :verify_none]})
    end

    def stop(state), do: :ok = :gun.shutdown(client(state, :pid))

    def get() do
        port = Application.get_env(:example, :service_port, 8080)
        tls = Application.get_env(:example, :tls, false)

        Logger.debug("port: #{port} tls: #{tls}")

        {:ok, pid} = open(port, tls)

        mref = :gun.get(pid, '/api')
        state = client(pid: pid, port: port, mref: mref)
        loop(state)
    end

    def send(state = client(ws_state: :ready), frames) do
        :ok = :gun.ws_send(client(state, :pid), frames)
    end

    def send(_state, _frames) do
        {:error, :websocket_unready}
    end

    def recv(state) do
        loop(state)
    end

    defp loop(state = client(pid: pid)) do
        receive do
            {:gun_up, ^pid, protocol} ->
                Logger.debug("[#{__MODULE__}] :gun_up")
                loop(client(state, protocol: protocol))

            {:gun_ws_upgrade, ^pid, :ok, headers} ->
                Logger.debug("[#{__MODULE__}] :gun_ws_upgrade")
                loop(client(pid: pid, headers: headers, ws_state: :ready))

            {:gun_response, ^pid, _stream_ref, :fin, _status, _headers} ->
                Logger.debug("[#{__MODULE__}] :gun_response")
                client(state, :data)

            {:gun_response, ^pid, stream_ref, :nofin, _status, _headers} ->
                Logger.debug("[#{__MODULE__}] :gun_response")
                loop(client(state, sref: stream_ref))

            {:gun_data, ^pid, _stream_ref, :fin, data} ->
                Logger.debug("[#{__MODULE__}] :gun_data")
                previous_data = client(state, :data)
                [data | previous_data]

            {:gun_data, ^pid, stream_ref, :nofin, data} ->
                Logger.debug("[#{__MODULE__}] :gun_data")
                previous_data = client(state, :data)
                loop(client(state, sref: stream_ref, data: [data | previous_data]))

            {:gun_ws, ^pid, frame} ->
                Logger.debug("[#{__MODULE__}] :gun_ws")
                frame

            {:DOWN, monitor_ref, :process, ^pid, reason} ->
                Logger.error("[#{__MODULE__} Received DOWN for process #{inspect pid} monitered by #{inspect monitor_ref} with reason: #{inspect reason}")

            unexpected ->
                Logger.debug("[#{__MODULE__}] Unexpected receive: #{inspect unexpected}")
                {:error, {:unexpected, unexpected}}

            after 5_000 ->
                {:error, :timeout}
        end
    end
end

ExUnit.start()
