defmodule Symbelix.Library.Memory do
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
