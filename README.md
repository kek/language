# Language

Parse and run programs.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `language` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:language, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/language](https://hexdocs.pm/language).

## Usage

```
$ iex -S mix
Erlang/OTP 21 [erts-10.2.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Language.Expression.parse("(one (two three) four)")
{:ok,
 [
   {:atom, 1, 'one'},
   [{:atom, 1, 'two'}, {:atom, 1, 'three'}],
   {:atom, 1, 'four'}
 ]}
iex(2)> Language.Expression.parse("(å)")
{:error, {1, :symbolic_expression_lexer, {:illegal, [229]}}, 1} 
iex(3)> Language.Expression.parse(")")
{:error, {1, :symbolic_expression_parser, ['syntax error before: ', '\')\'']}}
iex(4)> Language.run("(+ 1 1)")
2
iex(5)> Language.run("(public static void main)")
{:error,
 "Unknown atom 'public' at line 1 with parameters: [{:atom, 1, 'static'}, {:atom, 1, 'void'}, {:atom, 1, 'main'}]"}
iex(6)>
```
