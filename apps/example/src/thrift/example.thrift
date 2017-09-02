namespace csharp ElixirThriftExample

enum Type {
    MESSAGE_1,
    MESSAGE_2
}

struct Envelope
{
    1: required Type type;
    2: required Payload payload;
}

union Payload
{
    1: Message1 m1;
    2: Message2 m2;
}

struct Message1
{
    1: required string data;
}

struct Message2
{
    1: required i64 data;
}

