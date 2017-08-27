defmodule Common do

    # Exmaple use in erlang:
    # 1> {ok, C0} = thrift_client_util:new("localhost", 9090, thrift_test_thrift, []), ok. ok
    # 2> {C1, R1} = thrift_client:call(C0, testVoid, []), R1. {ok,ok}
    # 3> {C2, R2} = thrift_client:call(C1, testVoid, [asdf]), R2. {error,{bad_args,testVoid,[asdf]}}
    # 4> {C3, R3} = thrift_client:call(C2, testI32, [123]), R3. {ok,123}
    # 5> {C4, R4} = thrift_client:call(C3, testOneway, [1]), R4. {ok,ok}
    # 6> {C5, R5} = thrift_client:call(C4, testXception, ["foo"]), R5. {error,{no_function,testXception}}
    # 7> {C6, R6} = thrift_client:call(C5, testException, ["foo"]), R6. {ok,ok}
    # 8> {C7, R7} = (catch thrift_client:call(C6, testException, ["Xception"])), R7.
    # {exception,{xception,1001,<<"Xception">>}}

    # playground-specific

    # 1. define the record in elixir using the code in the thrift-generated hrl file

    # From types.ex
    ## Gateway Struct
    # see https://hexdocs.pm/elixir/1.4.5/Record.html#module-types
    Record.defrecord :payloadPlayer,
                     :'PayloadPlayer', Record.extract( :'PayloadPlayer',
                     from: "include/gen/gateway_types.hrl")
    @type payloadPlayer :: record(:payloadPlayer)

    # 2.
    # main serialization entrypoint
    def Gateway.toThrift(:player, gKey, {info, props, type, profile, groups, areas}) do
        # Need to serialize the props and the profile
        props   = Utils.Data.toPropertyMapRecord(props)
        profile = if(profile) do
                      {:ok, profile} = Player.serialize(gKey, :profile, type, profile)
                      profile
                  end
        Types.payloadPlayer(base:    info    |> Utils.Data.toThrift,
                            props:   props   |> Utils.Data.toThrift,
                            profile: profile |> Utils.Data.toThrift,
                            type:    type    |> Utils.Data.toThrift,
                            groups:  groups  |> Utils.Data.toThrift,
                            areas:   areas   |> Utils.Data.toThrift)
    end

    def toPropertyMapRecord(nil),   do: nil
    def toPropertyMapRecord(props) when is_binary(props), do: props
    def toPropertyMapRecord(props) when is_map(props), do: encodeMsgPack!(props)

    @spec encodeMsgPack!(term) :: binary
    def encodeMsgPack!(data),   do: encode!(:msgpack,data)

    @spec encode!(:json | :msgpack | :term, term) :: binary
    def encode!(:json,   data), do: Poison.encode!(data, [])
    def encode!(:msgpack,data), do: Utils.Data.M.pack(data) |> :erlang.iolist_to_binary
    def encode!(:term,   data), do: :erlang.term_to_binary(data, [:compressed])

    # 3. client-provided script callback to serialize
    @spec serialize(Types.Key.t, term, term, term) :: {:ok, binary} | {:error, atom}
    def serialize(gKey, category, type, data) do
        Player.Script.serialize(gKey, category, type, data)
    end


end
