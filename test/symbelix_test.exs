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

  defmodule Talker do
    use Symbelix.Library

    def say(string), do: string
  end

  defmodule ListProcessor do
    use Symbelix.Library

    def first([head | _]), do: head
  end

  defmodule Java do
  end

  defmodule Stateful do
    use Symbelix.Library
    require Logger
    alias SymbelixTest.Memory

    def add(a, b), do: a + b

    def set(name, value) do
      :ok = Memory.set(Memory, name, value)
      "ok"
    end

    def get(name) do
      Memory.get(Memory, name)
    end

    def inc(name) do
      set(name, get(name) + 1)
    end
  end

  defmodule Memory do
    def start_link do
      Agent.start_link(fn -> %{} end)
    end

    def set(pid, key, value) do
      Agent.update(pid, fn state -> Map.put(state, key, value) end)
    end

    def get(pid, key) do
      Agent.get(pid, fn state -> Map.get(state, key) end)
    end
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

    test "strings are literals" do
      assert Symbelix.run("(say \"foo\")", Talker) == "foo"
    end

    test "delayed computation" do
      assert Symbelix.run("(proc add 1 2)", Mathematician) ==
               {:proc, [{:atom, 1, 'add'}, {:number, 1, 1}, {:number, 1, 2}]}
    end

    test "explicit evaluation" do
      assert Symbelix.run("(apply (proc add 1 2))", Mathematician) == 3
    end

    test "running a proc" do
      assert Symbelix.run("(proc first [1 2])", ListProcessor) ==
               {:proc, [{:atom, 1, 'first'}, {:list, [{:number, 1, 1}, {:number, 1, 2}]}]}
    end

    test "delayed evaluation is delayed" do
      {:ok, memory} = Memory.start_link()
      Process.register(memory, Memory)
      assert Symbelix.run("(set x 1)", Stateful) == "ok"
      assert Symbelix.run("(get x)", Stateful) == 1
      assert Symbelix.run("(apply (proc inc x))", Stateful) == "ok"
      assert Symbelix.run("(get x)", Stateful) == 2
      assert Symbelix.run("(set f (proc inc x))", Stateful) == "ok"
      assert Symbelix.run("(get x)", Stateful) == 2
      assert Symbelix.run("(apply (get f))", Stateful) == "ok"
      assert Symbelix.run("(get x)", Stateful) == 3
    end
  end
end
