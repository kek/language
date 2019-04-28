defmodule Symbelix.Library.Standard do
  use Symbelix.Library
  alias Symbelix.Library.Memory

  def add(a, b), do: a + b
  def add(a, b, c), do: a + b + c

  def if(true, yes, _), do: yes
  def if(false, _, no), do: no

  def inc(n), do: n + 1

  def eq(a, b), do: a == b

  def identity(x), do: x
  def first([head | _]), do: head

  def set(name, value) do
    :ok = Memory.set(Memory, name, value)
    "ok"
  end

  def get(name) do
    Memory.get(Memory, name)
  end

  def incvar(name) do
    set(name, get(name) + 1)
  end

  def progn(items) do
    Enum.reduce(items, fn item, _ -> item end)
  end

  def map(list, function) do
    list
    |> Enum.map(fn item ->
      {:ok, ast} = generate_ast([function, item])
      {result, _binding} = Code.eval_quoted(ast)
      result
    end)
  end
end
