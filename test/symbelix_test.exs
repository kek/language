defmodule SymbelixTest do
  use ExUnit.Case
  import Symbelix

  alias Symbelix.TestHelpers.Libraries.{
    Mathematician,
    Controller,
    Talker,
    ListProcessor,
    Java,
    Stateful,
    Memory
  }

  doctest Symbelix

  describe "run" do
    test "runs a program" do
      assert Symbelix.run("(add 1 2)", Mathematician) == 3

      assert Symbelix.run("(add 1 2 3)", Mathematician) == 6

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

    test "strings are literals" do
      assert Symbelix.run("(say \"foo\")", Talker) == "foo"
    end
  end

  describe "code as data" do
    test "delayed computation" do
      assert Symbelix.run("(proc add 1 2)", Mathematician) ==
               {:proc, [{:atom, 1, 'add'}, {:number, 1, 1}, {:number, 1, 2}]}
    end

    test "explicit evaluation" do
      assert Symbelix.run("(eval (proc add 1 2))", Mathematician) == 3
    end

    test "running a proc" do
      assert Symbelix.run("(proc first [1 2])", ListProcessor) ==
               {:proc, [{:atom, 1, 'first'}, {:list, [{:number, 1, 1}, {:number, 1, 2}]}]}
    end

    test "running a proc stored in a variable" do
      Symbelix.Library.Memory.start_default()
      library = Symbelix.Library.Standard
      assert Symbelix.run("(set check-x (proc if (eq (get x) 0) zero nonzero))", library) == "ok"
      assert Symbelix.run("(set x 0)", library) == "ok"
      assert Symbelix.run("(eval (get check-x))", library) == 'zero'
      assert Symbelix.run("(set x 1)", library) == "ok"
      assert Symbelix.run("(eval (get check-x))", library) == 'nonzero'
    end

    test "running code from a proc stored in a variable" do
      Symbelix.Library.Memory.start_default()
      library = Symbelix.Library.Standard

      assert Symbelix.run("(set check-x (proc if (eq (get x) 0) (get y) (get z)))", library) ==
               "ok"

      assert Symbelix.run("(set x 0)", library) == "ok"
      assert Symbelix.run("(set y firsty)", library) == "ok"
      assert Symbelix.run("(set z firstz)", library) == "ok"
      assert Symbelix.run("(eval (get check-x))", library) == 'firsty'
      assert Symbelix.run("(set x 1)", library) == "ok"
      assert Symbelix.run("(eval (get check-x))", library) == 'firstz'
      assert Symbelix.run("(set z secondz)", library) == "ok"
      assert Symbelix.run("(eval (get check-x))", library) == 'secondz'
    end

    test "delayed evaluation is delayed" do
      {:ok, memory} = Memory.start_link()
      Process.register(memory, Memory)
      assert Symbelix.run("(set x 1)", Stateful) == "ok"
      assert Symbelix.run("(get x)", Stateful) == 1
      assert Symbelix.run("(eval (proc inc x))", Stateful) == "ok"
      assert Symbelix.run("(get x)", Stateful) == 2
      assert Symbelix.run("(set f (proc inc x))", Stateful) == "ok"
      assert Symbelix.run("(get x)", Stateful) == 2
      assert Symbelix.run("(eval (get f))", Stateful) == "ok"
      assert Symbelix.run("(get x)", Stateful) == 3
    end

    test "showing a list" do
      assert Symbelix.run("(identity [1 2 3])", ListProcessor) == [1, 2, 3]
    end
  end
end
