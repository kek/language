defmodule Language.ParserTest do
  use ExUnit.Case

  test "parse expressions with strings" do
    {:ok, tokens, _} = :symbolic_expression_lexer.string('("test string")')
    assert {:ok, [{:string, 1, "test string"}]} = :symbolic_expression_parser.parse(tokens)
  end
end
