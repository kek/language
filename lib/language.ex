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
  {:ok, {:apply, [context: Language.Library, import: Kernel], [LanguageTest.Mathematician, {{:., [], [{:__aliases__, [alias: false], [:List]}, :to_atom]}, [], ['add']}, [1, 2]]}}
  iex> compile([{:atom, 1, 'aliens'}, {:atom, 1, 'built'}, {:atom, 1, 'it'}], Mathematician)
  {:error, "Unknown function (atom) 'aliens' at line 1 with 2 parameters: 'built', 'it'"}
  iex> compile([{:atom, 1, '<?php'}], PHP)
  {:error, "The module PHP doesn't exist"}
  iex> compile([{:atom, 1, 'public'}], Java)
  {:error, "The module LanguageTest.Java doesn't implement Language.Library behaviour"}
  """
  def compile([{type, line, name} | params], library) do
    if :erlang.module_loaded(library) do
      values = Enum.map(params, &value_of/1)

      try do
        case library.generate_ast([name] ++ values) do
          {:ok, ast} ->
            {:ok, ast}

          {:error, :no_such_implementation} ->
            values_description =
              values
              |> Enum.map(&inspect/1)
              |> Enum.join(", ")

            {:error,
             "Unknown function (#{type}) '#{name}' at line #{line} with #{Enum.count(values)} parameters: #{
               values_description
             }"}
        end
      rescue
        UndefinedFunctionError ->
          {:error, "The module #{inspect(library)} doesn't implement Language.Library behaviour"}
      end
    else
      {:error, "The module #{inspect(library)} doesn't exist"}
    end
  end

  defp eval(ast) do
    {result, _binding} = Code.eval_quoted(ast)
    result
  end

  defp value_of({:number, _, value}), do: value
  defp value_of({:atom, _, value}), do: value
end
