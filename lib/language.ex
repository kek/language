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
  iex> Language.run("(aliens built this)")
  {:error, "Unknown atom 'aliens' at line 1 with parameters: [{:atom, 1, 'built'}, {:atom, 1, 'this'}]"}
  """
  def run(source) do
    with {:ok, code} <- Expression.parse(source),
         {:ok, ast} <- compile(code) do
      eval(ast)
    end
  end

  @doc """
  Compiles a symbolic expression to Elixir AST.

  Examples:
  iex> compile([{:operator, 1, '+'}, {:number, 1, 1}, {:number, 1, 2}])
  {:ok, {:+, [], [1, 2]}}
  iex> compile([{:atom, 1, 'aliens'}, {:atom, 1, 'built'}, {:atom, 1, 'this'}])
  {:error, "Unknown atom 'aliens' at line 1 with parameters: [{:atom, 1, 'built'}, {:atom, 1, 'this'}]"}
  """
  def compile([{:operator, 1, '+'} | params]), do: {:ok, ast(:+, params)}

  def compile([{type, line, name} | params]) do
    {:error, "Unknown #{type} '#{name}' at line #{line} with parameters: #{inspect(params)}"}
  end

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
