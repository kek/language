defmodule Language do
  alias Language.Expression

  @moduledoc """
  Documentation for Language.
  """

  def run(source, library) do
    with {:ok, code} <- Expression.parse(source),
         {:ok, ast} <- compile(code, library) do
      eval(ast)
    end
  end

  @doc """
  Compiles a symbolic expression to Elixir AST.

  Examples:
  iex> compile([{:atom, 1, 'add'}, {:number, 1, 1}, {:number, 1, 2}], Mathematician)
  {:ok, {:+, [], [1, 2]}}
  iex> compile([{:atom, 1, 'aliens'}, {:atom, 1, 'built'}, {:atom, 1, 'this'}], Mathematician)
  {:error, "Unknown atom 'aliens' at line 1 with parameters: ['built', 'this']"}
  iex> compile([{:atom, 1, '<?php'}], PHP)
  {:error, "The module PHP doesn't exist, or it doesn't implement call({name, params})"}
  iex> compile([{:atom, 1, 'public'}], Java)
  {:error, "The module LanguageTest.Java doesn't exist, or it doesn't implement call({name, params})"}
  """
  def compile([{type, line, name} | params], library) do
    values = Enum.map(params, &value_of/1)

    try do
      {:ok, library.call({name, values})}
    rescue
      UndefinedFunctionError ->
        {:error,
         "The module #{inspect(library)} doesn't exist, or it doesn't implement call({name, params})"}

      FunctionClauseError ->
        {:error, "Unknown #{type} '#{name}' at line #{line} with parameters: #{inspect(values)}"}
    end
  end

  defp eval(ast) do
    {result, _binding} = Code.eval_quoted(ast)
    result
  end

  defp value_of({:number, _, value}), do: value
  defp value_of({:atom, _, value}), do: value
end
