defmodule LanguageTest do
  use ExUnit.Case
  import Language
  alias LanguageTest.Mathematician

  defmodule Mathematician do
    @behaviour Language.Library
    def call({'add', params}), do: {:+, [], params}
  end

  defmodule Java do
  end

  doctest Language

  describe "run" do
    test "runs a program" do
      assert Language.run("(add 1 2)", Mathematician) == 3

      assert Language.run("(aliens built this)", Mathematician) ==
               {:error, "Unknown atom 'aliens' at line 1 with parameters: ['built', 'this']"}
    end
  end
end
