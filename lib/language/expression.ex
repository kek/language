defmodule Language.Expression do
  @doc """
  Parses a symbolic expression.

  Examples:

  iex> parse("(steve!)")
  {:ok, [{:atom, 1, 'steve!'}]}

  iex> parse("(steve! steve!)")
  {:ok, [{:atom, 1, 'steve!'}, {:atom, 1, 'steve!'}]}

  iex> parse("(steve! (steve!))")
  {:ok, [{:atom, 1, 'steve!'}, [{:atom, 1, 'steve!'}]]}

  iex> parse("(steve! (steve! steve!))")
  {:ok, [{:atom, 1, 'steve!'}, [{:atom, 1, 'steve!'}, {:atom, 1, 'steve!'}]]}

  iex> parse("(steve! (steve! steve!) steve!)")
  {:ok, [{:atom, 1, 'steve!'}, [{:atom, 1, 'steve!'}, {:atom, 1, 'steve!'}], {:atom, 1, 'steve!'}]}

  iex> parse("(42)")
  {:ok, [{:number, 1, 42}]}

  iex> parse("(pete_pete_pete)")
  {:ok, [{:atom, 1, 'pete_pete_pete'}]}

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
  """
  def parse(code) do
    with {:ok, tokens, _} <- code |> String.to_charlist() |> :symbolic_expression_lexer.string(),
         {:ok, tree} <- :symbolic_expression_parser.parse(tokens) do
      {:ok, tree}
    end
  end
end
