Definitions.

Whitespace  = [\000-\s]
Chars       = [a-z!?_]+
LeftParen   = \(
RightParen  = \)
Number      = [0-9]+
Operator    = [+\-/*%$&=\\]

Rules.

{Whitespace}  : skip_token.
{LeftParen}   : {token, {'(', TokenLine}}.
{RightParen}  : {token, {')', TokenLine}}.
{Chars}       : {token, {atom, TokenLine, TokenChars}}.
{Number}      : {token, {number, TokenLine, TokenChars}}.
{Operator}    : {token, {operator, TokenLine, TokenChars}}.

Erlang code.
