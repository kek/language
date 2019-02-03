defmodule Language do
  alias Language.Expression

  @moduledoc """
  Documentation for Language.
  """

  @spec run(source :: String.t(), library :: Module.t()) :: any()
  @doc """
  Runs a program specified by the source code `source` together with
  the function library `library`. Returns the result of the program,
  or an {:error, message} tuple in case of an error.

  ## Examples:

      iex> Language.run("(add 1 2)", Mathematician)
      3

      iex> Language.run("(sub 1 2)", Mathematician)
      {:error, "Unknown function (atom) 'sub' at line 1 with 2 parameter(s): (1 2)"}
  """
  def run(source, library) do
    with {:ok, code} <- Expression.parse(source),
         {:ok, ast} <- compile(code, library) do
      eval(ast)
    end
  end

  @doc """
  Compiles a symbolic expression to Elixir AST.

  ## Examples:

      iex> compile([{:atom, 1, 'add'}, {:number, 1, 1}, {:number, 1, 2}], Mathematician)
      {:ok, {:apply, [context: Language.Library, import: Kernel], [LanguageTest.Mathematician, :add, [1, 2]]}}

      iex> compile([{:atom, 1, 'aliens'}, {:atom, 1, 'built'}, {:atom, 1, 'it'}], Mathematician)
      {:error, "Unknown function (atom) 'aliens' at line 1 with 2 parameter(s): (built it)"}

      iex> compile([{:atom, 1, '<?php'}], PHP)
      {:error, "The module PHP doesn't exist"}

      iex> compile([{:atom, 1, 'public'}], Java)
      {:error, "The module LanguageTest.Java doesn't implement Language.Library behaviour"}
  """
  def compile([{type, line, name} | params], library) do
    if :erlang.module_loaded(library) do
      values = Enum.map(params, &value_of(&1, library))

      try do
        case library.generate_ast([name] ++ values) do
          {:ok, ast} ->
            {:ok, ast}

          {:error, :no_such_implementation} ->
            values_description =
              values
              |> Enum.map(&"#{&1}")
              |> Enum.join(" ")

            {:error,
             "Unknown function (#{type}) '#{name}' at line #{line} with #{Enum.count(values)} parameter(s): (#{
               values_description
             })"}
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

  defp value_of({:number, _, value}, _), do: value
  defp value_of({:atom, _, value}, _), do: value

  defp value_of(expression, library) when is_list(expression) do
    {:ok, ast} = compile(expression, library)
    ast
  end
end
