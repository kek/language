# Symbelix

Parse symbolic expressions and evaluate them as programs.

## Usage

```
$ iex -S mix
Erlang/OTP 21 [erts-10.2.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Symbelix.Expression.parse("(one (two three) four)")
{:ok,
 [
   {:atom, 1, 'one'},
   [{:atom, 1, 'two'}, {:atom, 1, 'three'}],
   {:atom, 1, 'four'}
 ]}
iex(2)> Symbelix.Expression.parse("(å)")
{:error, {1, :symbolic_expression_lexer, {:illegal, [229]}}, 1} 
iex(3)> Symbelix.Expression.parse(")")
{:error, {1, :symbolic_expression_parser, ['syntax error before: ', '\')\'']}}
iex(4)>   defmodule Mathematician do
...(4)>     use Symbelix.Library
...(4)>     def add(a, b), do: a + b
...(4)>   end
{:module, Mathematician,
 <<70, 79, 82, 49, 0, 0, 8, 252, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 1, 1, 0,
   0, 0, 28, 20, 69, 108, 105, 120, 105, 114, 46, 77, 97, 116, 104, 101, 109,
   97, 116, 105, 99, 105, 97, 110, 8, 95, ...>>, {:add, 2}}
iex(5)> Symbelix.run("(add 1 1)", Mathematician)
2
iex(6)> Symbelix.run("(public static void main)", Mathematician)
{:error,
 "Unknown function (atom) 'public' at line 1 with 3 parameters: ('static', 'void', 'main')"}
iex(7)>
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `symbelix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:symbelix, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/symbelix](https://hexdocs.pm/symbelix).
