defmodule Symbelix.LexerTest do
  use ExUnit.Case

  test "lex strings" do
    assert :symbolic_expression_lexer.string('("yo")') ==
             {:ok, [{:"(", 1}, {:string, 1, '"yo"'}, {:")", 1}], 1}
  end
end
