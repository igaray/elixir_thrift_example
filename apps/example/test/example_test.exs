defmodule Example.Test do
    require Logger
    use ExUnit.Case

    doctest Example

    test "rest client" do
        ["{\"result\":\"ok\"}"] = Example.Test.Client.get()
    end

    test "websocket client" do
        case Example.Test.Client.start() do
            {:error, error} ->
                flunk "error: #{inspect error}"
            {:ok, client} ->
                Example.Test.Client.send(client, {:text, "hello"})
                {:text, "hello"} = Example.Test.Client.recv(client)

                Example.Test.Client.send(client, {:text, "there"})
                {:text, "there"} = Example.Test.Client.recv(client)

                Example.Test.Client.stop(client)
            end
    end
end
