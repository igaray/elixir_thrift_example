defmodule Example.Handler.Rest do
    require Logger

    def init(req, opts) do
        {:cowboy_rest, req, opts}
    end

    def allowed_methods(req, state) do
        {["GET", "POST"], req, state}
    end

    def content_types_provided(req, state) do
        {[{"application/json", :handle_get}], req, state}
    end

    def content_types_accepted(req, state) do
        {[{"application/json", :handle_post}], req, state}
    end

    def allow_missing_post() do true end

    def handle_get(req, state) do
        Logger.info("[#{__MODULE__}] GET")
        {"{\"result\":\"ok\"}", req, state}
    end

    def handle_api_post(req, state) do
        Logger.info("[#{__MODULE__}] POST")
        {false, req, state}
    end
end