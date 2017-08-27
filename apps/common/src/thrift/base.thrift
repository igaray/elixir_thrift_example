namespace csharp ElixirThriftExample

struct Message
{
    1: required i16 len;
    2: required i16 protocol_vsn;
    3: required i16 session;
    4: optional string payload = "0";
}
