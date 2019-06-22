defmodule Symbelix.TestHelpers.Libraries do
  defmodule Mathematician do
    use Symbelix.Library

    def add([a, b]), do: a + b
    def add([a, b, c]), do: a + b + c
  end

  defmodule Controller do
    use Symbelix.Library

    def if(['true', yes, _]), do: yes
    def if(['false', _, no]), do: no

    def inc([n]), do: n + 1
  end

  defmodule Talker do
    use Symbelix.Library

    def say([string]), do: string
  end

  defmodule ListProcessor do
    use Symbelix.Library

    def identity([x]), do: x
    def first([[head | _]]), do: head
  end

  defmodule Java do
  end

  defmodule Stateful do
    use Symbelix.Library
    require Logger
    alias Symbelix.TestHelpers.Libraries.Memory

    def add([a, b]), do: a + b

    def set([name, value]) do
      :ok = Memory.set(Memory, name, value)
      "ok"
    end

    def get([name]) do
      Memory.get(Memory, name)
    end

    def inc([name]) do
      set([name, get([name]) + 1])
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
end
