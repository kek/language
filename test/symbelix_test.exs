defmodule SymbelixTest do
  use ExUnit.Case
  import Symbelix
  alias SymbelixTest.Mathematician

  defmodule Mathematician do
    use Symbelix.Library

    def add(a, b), do: a + b
    def add(a, b, c), do: a + b + c
  end

  defmodule Controller do
    use Symbelix.Library

    def if('true', yes, _), do: yes
    def if('false', _, no), do: no

    def inc(n), do: n + 1
  end

  defmodule Java do
  end

  doctest Symbelix

  describe "run" do
    test "runs a program" do
      assert Symbelix.run("(add 1 2)", Mathematician) == 3

      assert Symbelix.run("(add 1 2 3)", Mathematician) == 6

      assert Symbelix.run("(add 1 2 3 4)", Mathematician) ==
               {:error, "Unknown function (atom) 'add' at line 1 with 4 parameter(s): (1 2 3 4)"}

      assert Symbelix.run("(aliens built it)", Mathematician) ==
               {:error,
                "Unknown function (atom) 'aliens' at line 1 with 2 parameter(s): (built it)"}
    end

    test "control flow" do
      assert Symbelix.run("(if true yes no)", Controller) == 'yes'
      assert Symbelix.run("(if false yes no)", Controller) == 'no'
    end

    test "nested evaluation" do
      assert Symbelix.run("(if true (inc 1) no)", Controller) == 2
    end
  end
end
