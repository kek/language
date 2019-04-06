Nonterminals list elements element quoted.
Terminals atom '(' ')' '[' ']' number operator string.
Rootsymbol list.

list -> '(' elements ')' : '$2'.
elements -> element elements : ['$1'] ++ '$2'.
elements -> '$empty' : [].
element -> atom : '$1'.
element -> list : '$1'.
element -> quoted : {list, '$1'}.
element -> string : to_binary('$1').
element -> number : to_integer('$1').
element -> operator : '$1'.
quoted -> '[' elements ']' : '$2'.

Erlang code.

to_integer({number, TokenLine, TokenChars}) -> {number, TokenLine, list_to_integer(TokenChars)}.
to_binary({string, Line, Value}) ->
    ValueBinary = 'Elixir.List':to_string(Value),
    {ok, ParsedString} = 'Elixir.Code':string_to_quoted(ValueBinary),
    {string, Line, ParsedString}.
