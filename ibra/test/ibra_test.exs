defmodule IbraTest do
  use ExUnit.Case
  doctest Ibra

  test "greets the world" do
    assert Ibra.hello() == :world
  end
end
