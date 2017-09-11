namespace csharp ElixirThriftExample

enum Error {
    NONE,
    ERROR1,
    ERROR2
}

enum MessageType {
    REQUEST1,
    RESPONSE1,
    REQUEST2,
    RESPONSE2,
    MESSAGE1
}

struct Envelope {
    1: required MessageType type;
    2: required Payload payload;
}

union Payload {
    1: Request1 r1;
    2: Request2 r2;
    3: Message1 m1;
}

struct Request1 {
    1: required string data;
}

struct Response1 {
    1: required Error result;
    2: required string data;
}

struct Request2 {
    1: required i64 data;
}

struct Response2 {
    1: required Error result;
    2: required i64 data;
}

struct Message1 {
    1: required i64 data;
}
