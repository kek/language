defmodule Language.Library do
  @callback call({name :: list(), params :: list()}) :: {:ok, tuple()} | {:error, tuple()}
end
