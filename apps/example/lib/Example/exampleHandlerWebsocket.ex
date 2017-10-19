defmodule Example.Handler.Websocket do
    require Logger
    require Record

    Record.defrecordp(:state,
        opts: nil)

    def init(req, opts) do
        {:cowboy_websocket, req, state(opts: opts)}
    end

    def websocket_handle({:binary, envelope}, state) do
        Logger.debug("[#{__MODULE__}] Received binary: #{inspect envelope}")
        try do
            # case Chat.Protocol.V2.handleProtocolRequestMessage(envelope) do
            #     {gKey, pKey, reply} ->
            #         # We make the protocol handler return the gKey, pKey because
            #         # we want to keep it in the websocket handler state
            #         state = state(state, gKey: gKey, pKey: pKey)
            #         case reply do
            #             :noreply ->
            #                 {:ok, state}
            #             reply ->
            #                 {:reply, {:binary, reply}, state}
            #         end
            #     {:error, error} ->
            #         Logger.error("[Chat.Connection.V2] Protocol error: #{inspect error}")
            #         # TODO: the websocket handler should only close the
            #         # connection on UNEXPECTED errors. Protocol errors (e.g.
            #         # unauthorized, forbidden, unexpected input, unknown
            #         # protocol payload, etc.) should return a protocol error
            #         # response to the client.
            #         {:stop, state}
            # end
            {:reply, {:binary, "result: ok"}, state}
        rescue
            error ->
                Logger.error("""
                    [#{__MODULE__}.websocket_handle]
                        error: #{inspect error}
                        stacktrace:\n#{Exception.format_stacktrace(System.stacktrace)}
                    """)
        end
    end
    def websocket_handle({:text, text}, state) do
        Logger.debug("[#{__MODULE__}] Received text: #{inspect text}")
        {:reply, {:text, text}, state}
    end
    def websocket_handle(:ping, state) do
        Logger.debug("[#{__MODULE__}] Ping")
        {:ok, state}
    end
    def websocket_handle(:pong, state) do
        Logger.debug("[#{__MODULE__}] Pong")
        {:ok, state}
    end

    def websocket_info(info, state) do
        Logger.warn("[#{__MODULE__}] Received unexpected message: #{inspect info}")
        {:ok, state}
    end
end