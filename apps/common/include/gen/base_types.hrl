-ifndef(_base_types_included).
-define(_base_types_included, yeah).

%% struct 'Message'

-record('Message', {'len' :: integer(),
                    'protocol_vsn' :: integer(),
                    'session' :: integer(),
                    'payload' = "0" :: string() | binary()}).
-type 'Message'() :: #'Message'{}.

-endif.
