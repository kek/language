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

      iex> parse("(fun)")
      {:ok, [{:atom, 1, 'fun'}]}

      iex> parse("(fun [])")
      {:ok, [{:atom, 1, 'fun'}, {:list, []}]}

      iex> parse("(fun [1 2 3])")
      {:ok, [{:atom, 1, 'fun'}, {:list, [{:number, 1, 1}, {:number, 1, 2}, {:number, 1, 3}]}]}

      iex> parse("(1)")
      {:ok, [{:number, 1, 1}]}
  """
  def parse(code) do
    with {:ok, tokens, _} <- code |> String.to_charlist() |> :symbolic_expression_lexer.string(),
         {:ok, tree} <- :symbolic_expression_parser.parse(tokens) do
      {:ok, tree}
    end
  end
end
