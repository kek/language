defmodule Language.Library do
  @callback generate_ast(parse_tree :: list()) :: {:ok, tuple()} | {:error, tuple()}

  defmacro __using__(_opts) do
    quote do
      @behaviour Language.Library

      def generate_ast([function | params]) do
        available_functions =
          __MODULE__.module_info()[:exports]
          |> Enum.map(fn {fun, arity} ->
            {Atom.to_charlist(fun), arity}
          end)

        if {function, Enum.count(params)} in available_functions do
          {:ok,
           quote(do: apply(unquote(__MODULE__), unquote(List.to_atom(function)), unquote(params)))}
        else
          {:error, :no_such_implementation}
        end
      end
    end
  end
end
