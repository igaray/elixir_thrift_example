defmodule Example.App do
    import Supervisor.Spec, warn: false
    require Logger
    use Application

    def start(_type, _args) do
        Logger.info("[#{__MODULE__}] Starting application")
        out = launch()
        Logger.info("[#{__MODULE__}] Application ready")
        out
    end

    defp launch() do
        opts = [strategy: :one_for_one, name: Example.Supervisor]
        out = Supervisor.start_link(children(), opts)
        start_service()
        out
    end

    defp children(), do: []

    defp start_service() do
        service_port = Application.get_env(:example, :service_port, 8080)
        service_timeout = Application.get_env(:example, :service_timeout, 5000)
        tls = Application.get_env(:example, :tls, false)

        dispatch = :cowboy_router.compile([{:_, routes()}])
        protocol_opts =
            %{
                :env => %{:dispatch => dispatch},
                :request_timeout => service_timeout
            }
        case tls do
            true ->
                Logger.debug("[#{__MODULE__}] TLS enabled")
                # cacertfile = Application.get_env(:example, :cacertfile, 'priv/certs/cacertfile.crt')
                certfile = Application.get_env(:example, :certfile, 'priv/certs/certfile.crt')
                keyfile = Application.get_env(:example, :keyfile, 'priv/certs/keyfile.key')

                transport_opts =
                    [
                        {:verify, :verify_none},
                        {:port, service_port},
                        # {:cacertfile, cacertfile},
                        {:certfile, certfile},
                        {:keyfile, keyfile}
                    ]
                {:ok, _pid} = :cowboy.start_tls(:example_service, transport_opts, protocol_opts)
            false ->
                Logger.debug("[#{__MODULE__}] TLS disabled")
                transport_opts = [{:port, service_port}]
                {:ok, _pid} = :cowboy.start_clear(:example_service, transport_opts, protocol_opts)
        end
        Logger.debug("[#{__MODULE__}] Cowboy listening on port #{service_port}")
    end

    defp routes() do
        [
            {"/api", Example.Handler.Rest, []},
            {"/ws", Example.Handler.Websocket, []},
        ]
    end
end