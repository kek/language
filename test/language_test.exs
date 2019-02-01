defmodule LanguageTest do
  use ExUnit.Case
  import Language
  alias LanguageTest.Mathematician

  defmodule Mathematician do
    @behaviour Language.Library
    def call({'add', params}) do
      quote do
        apply(Kernel, :+, unquote(params))
      end
    end
  end

  defmodule Java do
  end

  doctest Language

  describe "run" do
    test "runs a program" do
      assert Language.run("(add 1 2)", Mathematician) == 3

      assert Language.run("(aliens built it)", Mathematician) ==
               {:error,
                "Unknown function (atom) 'aliens' at line 1 with parameters: ['built', 'it']"}
    end
  end
end
