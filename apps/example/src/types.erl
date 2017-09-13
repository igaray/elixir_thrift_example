-module(types).

% -include("../include/gen/example_types.hrl").

% -export([type_to_tag/1]).
% -export([tag_to_type/1]).

% type_to_tag(?EXAMPLE_TYPE_MESSAGE_1) -> 'Message1';
% type_to_tag(?EXAMPLE_TYPE_MESSAGE_2) -> 'Message2'.

% tag_to_type('Message1') -> ?EXAMPLE_TYPE_MESSAGE_1;
% tag_to_type('Message2') -> ?EXAMPLE_TYPE_MESSAGE_2.
