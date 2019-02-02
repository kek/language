Definitions.

Whitespace = [\000-\s]
Atom       = [A-Za-z][A-Za-z!?_\-\.:]+
LeftParen  = \(
RightParen = \)
Number     = [0-9]+
Operator   = [+\-/*%$&=\\]
String     = \"[^\"]*\"

Rules.

{Whitespace} : skip_token.
{LeftParen}  : {token, {'(', TokenLine}}.
{RightParen} : {token, {')', TokenLine}}.
{Atom}       : {token, {atom, TokenLine, TokenChars}}.
{Number}     : {token, {number, TokenLine, TokenChars}}.
{Operator}   : {token, {operator, TokenLine, TokenChars}}.
{String}     : {token, {string, TokenLine, TokenChars}}.

Erlang code.
