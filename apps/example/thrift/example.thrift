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
    1: Request1 req1;
    2: Response1 rsp1;
    3: Request2 req2;
    4: Response2 rsp2;
    5: Message1 msg1;
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
