defmodule Language do
  alias Language.Expression

  @moduledoc """
  Documentation for Language.
  """

  @doc """
  Runs a program.

  Examples:
  iex> Language.run("(+ 1 2)")
  3
  """
  def run(source) do
    {:ok, code} = Expression.parse(source)
    {:ok, ast} = compile(code)
    eval(ast)
  end

  @doc """
  Compiles a symbolic expression to Elixir AST.

  Examples:
  iex> compile([{:operator, 1, '+'}, {:number, 1, 1}, {:number, 1, 2}])
  {:ok, {:+, [], [1, 2]}}
  """
  def compile([{:operator, 1, '+'} | params]), do: {:ok, ast(:+, params)}

  defp ast(:+, params) do
    values = Enum.map(params, &value_of/1)
    {:+, [], values}
  end

  defp eval(ast) do
    {result, _binding} = Code.eval_quoted(ast)
    result
  end

  defp value_of({:number, _, value}), do: value
end
