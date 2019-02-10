defmodule Symbelix.Expression do
  @doc """
  Parses a symbolic expression.

  ## Examples:

      iex> parse("(steve!)")
      {:ok, [{:atom, 1, 'steve!'}]}

      iex> parse("(Steve! STEVE!)")
      {:ok, [{:atom, 1, 'Steve!'}, {:atom, 1, 'STEVE!'}]}

      iex> parse("(steve! (steve!))")
      {:ok, [{:atom, 1, 'steve!'}, [{:atom, 1, 'steve!'}]]}

      iex> parse("(steve! (steve! steve!))")
      {:ok, [{:atom, 1, 'steve!'}, [{:atom, 1, 'steve!'}, {:atom, 1, 'steve!'}]]}

      iex> parse("(steve! (steve! steve!) steve!)")
      {:ok, [{:atom, 1, 'steve!'}, [{:atom, 1, 'steve!'}, {:atom, 1, 'steve!'}], {:atom, 1, 'steve!'}]}

      iex> parse("(42)")
      {:ok, [{:number, 1, 42}]}

      iex> parse("(pete_pete.pete-pete:pete)")
      {:ok, [{:atom, 1, 'pete_pete.pete-pete:pete'}]}

      iex> parse("(+ - / * % $ & = \\\\)")
      {:ok, [{:operator, 1, '+'},
             {:operator, 1, '-'},
             {:operator, 1, '/'},
             {:operator, 1, '*'},
             {:operator, 1, '%'},
             {:operator, 1, '$'},
             {:operator, 1, '&'},
             {:operator, 1, '='},
             {:operator, 1, '\\\\'}]}

      iex> parse("(f)")
      {:ok, [{:atom, 1, 'f'}]}
  """
  def parse(code) do
    with {:ok, tokens, _} <- code |> String.to_charlist() |> :symbolic_expression_lexer.string(),
         {:ok, tree} <- :symbolic_expression_parser.parse(tokens) do
      {:ok, tree}
    end
  end
end
