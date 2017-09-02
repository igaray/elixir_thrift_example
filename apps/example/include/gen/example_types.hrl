-ifndef(_example_types_included).
-define(_example_types_included, yeah).

-define(EXAMPLE_TYPE_MESSAGE_1, 0).
-define(EXAMPLE_TYPE_MESSAGE_2, 1).

%% struct 'Envelope'

-record('Envelope', {'type' :: integer(),
                     'payload' :: 'Payload'()}).
-type 'Envelope'() :: #'Envelope'{}.

%% struct 'Payload'

-record('Payload', {'m1' :: 'Message1'(),
                    'm2' :: 'Message2'()}).
-type 'Payload'() :: #'Payload'{}.

%% struct 'Message1'

-record('Message1', {'data' :: string() | binary()}).
-type 'Message1'() :: #'Message1'{}.

%% struct 'Message2'

-record('Message2', {'data' :: integer()}).
-type 'Message2'() :: #'Message2'{}.

-endif.
