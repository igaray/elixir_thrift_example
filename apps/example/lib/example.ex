defmodule Example do
    use Application
    require Record

    Record.defrecord :envelope, :'Envelope', Record.extract( :'Envelope', from: "include/gen/example_types.hrl")
    @type envelope :: record(:envelope)

    Record.defrecord :payload, :'Payload', Record.extract( :'Payload', from: "include/gen/example_types.hrl")
    @type payload :: record(:payload)

    Record.defrecord :message1, :'Message1', Record.extract( :'Message1', from: "include/gen/example_types.hrl")
    @type message1 :: record(:message1)

    Record.defrecord :message2, :'Message2', Record.extract( :'Message1', from: "include/gen/example_types.hrl")
    @type message2 :: record(:message2)

    def serialize(_record) do
        <<"">>
    end

    def deserialize(_binary) do
        {}
    end

    def start(_type, _args) do
        import Supervisor.Spec, warn: false
        children = []
        opts = [strategy: :one_for_one, name: Example2.Supervisor]
        Supervisor.start_link(children, opts)
    end
end
