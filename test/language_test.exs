defmodule LanguageTest do
  use ExUnit.Case
  doctest Language

  test "greets the world" do
    assert Language.hello() == :world
  end
end
