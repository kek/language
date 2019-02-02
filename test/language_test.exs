defmodule LanguageTest do
  use ExUnit.Case
  import Language
  alias LanguageTest.Mathematician

  defmodule Mathematician do
    use Language.Library

    def add(a, b), do: a + b
    def add(a, b, c), do: a + b + c
  end

  defmodule Java do
  end

  doctest Language

  describe "run" do
    test "runs a program" do
      assert Language.run("(add 1 2)", Mathematician) == 3

      assert Language.run("(add 1 2 3)", Mathematician) == 6

      assert Language.run("(add 1 2 3 4)", Mathematician) ==
               {:error, "Unknown function (atom) 'add' at line 1 with 4 parameters: 1, 2, 3, 4"}

      assert Language.run("(aliens built it)", Mathematician) ==
               {:error,
                "Unknown function (atom) 'aliens' at line 1 with 2 parameters: 'built', 'it'"}
    end
  end
end
