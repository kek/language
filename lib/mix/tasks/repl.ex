defmodule Mix.Tasks.Repl do
  use Mix.Task

  def run([]) do
    Symbelix.repl()
  end
end
