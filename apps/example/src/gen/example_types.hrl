-ifndef(_example_types_included).
-define(_example_types_included, yeah).

-define(EXAMPLE_ERROR_NONE, 0).
-define(EXAMPLE_ERROR_ERROR1, 1).
-define(EXAMPLE_ERROR_ERROR2, 2).

-define(EXAMPLE_MESSAGETYPE_REQUEST1, 0).
-define(EXAMPLE_MESSAGETYPE_RESPONSE1, 1).
-define(EXAMPLE_MESSAGETYPE_REQUEST2, 2).
-define(EXAMPLE_MESSAGETYPE_RESPONSE2, 3).
-define(EXAMPLE_MESSAGETYPE_MESSAGE1, 4).

%% struct 'Envelope'

-record('Envelope', {'type' :: integer(),
                     'payload' :: 'Payload'()}).
-type 'Envelope'() :: #'Envelope'{}.

%% struct 'Payload'

-record('Payload', {'req1' :: 'Request1'(),
                    'rsp1' :: 'Response1'(),
                    'req2' :: 'Request2'(),
                    'rsp2' :: 'Response2'(),
                    'msg1' :: 'Message1'()}).
-type 'Payload'() :: #'Payload'{}.

%% struct 'Request1'

-record('Request1', {'data' :: string() | binary()}).
-type 'Request1'() :: #'Request1'{}.

%% struct 'Response1'

-record('Response1', {'result' :: integer(),
                      'data' :: string() | binary()}).
-type 'Response1'() :: #'Response1'{}.

%% struct 'Request2'

-record('Request2', {'data' :: integer()}).
-type 'Request2'() :: #'Request2'{}.

%% struct 'Response2'

-record('Response2', {'result' :: integer(),
                      'data' :: integer()}).
-type 'Response2'() :: #'Response2'{}.

%% struct 'Message1'

-record('Message1', {'data' :: integer()}).
-type 'Message1'() :: #'Message1'{}.

-endif.
