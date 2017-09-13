defmodule Example do
    use Application
    require Logger
    require Record

    defmodule Types do

        @example_error_none 0
        @example_error_error1 1
        @example_error_error2 2
        @example_messagetype_request1 0
        @example_messagetype_response1 1
        @example_messagetype_request2 2
        @example_messagetype_response2 3
        @example_messagetype_message1 4

        def tag_to_thrift(:'Request1'), do: 0
        def tag_to_thrift(:'Response1'), do: 1
        def tag_to_thrift(:'Request2'), do: 2
        def tag_to_thrift(:'Response2'), do: 3
        def tag_to_thrift(:'Message1'), do: 4

        def tag_to_thrift(0), do: :'Request1'
        def tag_to_thrift(1), do: :'Response1'
        def tag_to_thrift(2), do: :'Request2'
        def tag_to_thrift(3), do: :'Response2'
        def tag_to_thrift(4), do: :'Message1'

        Record.defrecord :envelope, :'Envelope', Record.extract(:'Envelope', from: "src/gen/example_types.hrl")
        @type envelope :: record(:envelope)

        Record.defrecord :payload, :'Payload', Record.extract(:'Payload', from: "src/gen/example_types.hrl")
        @type payload :: record(:payload)

        Record.defrecord :request1, :'Request1', Record.extract(:'Request1', from: "src/gen/example_types.hrl")
        @type request1 :: record(:request1)

        Record.defrecord :response1, :'Response1', Record.extract(:'Response1', from: "src/gen/example_types.hrl")
        @type response1 :: record(:response1)

        Record.defrecord :request2, :'Request2', Record.extract(:'Request2', from: "src/gen/example_types.hrl")
        @type request2 :: record(:request2)

        Record.defrecord :response2, :'Response2', Record.extract(:'Response2', from: "src/gen/example_types.hrl")
        @type response2 :: record(:response2)

        Record.defrecord :message1, :'Message1', Record.extract(:'Message1', from: "src/gen/example_types.hrl")
        @type message1 :: record(:message1)

    end

    defmodule Thrift do
        def serialize(record) do
            try do
                type = :erlang.element(1, record)
                {:ok, transport} = :thrift_memory_buffer.new()
                {:ok, protocol} = :thrift_binary_protocol.new(transport)
                {protocol2, :ok} = :thrift_protocol.write(protocol, {:example_types.struct_info(type), record})
                case :thrift_protocol.close_transport(protocol2) do
                    :ok ->
                        <<"">>
                    {comp, :ok} ->
                        {_, {_, _, {_, buf}}, _, _, _, _} = comp
                        buf
                end
            rescue
                error ->
                    Logger.error("""
                    Failed to serialize a thrift message.
                        Error: #{inspect error}
                        Record: #{inspect record}
                    """)
                    raise error
            end
        end

        def deserialize(tag,  binary) do
            {:ok, transport} = :thrift_memory_buffer.new(binary)
            {:ok, protocol} = :thrift_binary_protocol.new(transport)
            {_, {_, msg}} = :thrift_protocol.read(protocol, :example_types.struct_info(tag), tag)
            msg
        end
    end

    def start(_type, _args) do
        import Supervisor.Spec, warn: false
        children = []
        opts = [strategy: :one_for_one, name: Example2.Supervisor]
        Supervisor.start_link(children, opts)
    end
end
