defmodule AntichristTest do
  use ExUnit.Case
  doctest Antichrist

  test "greets the world" do
    assert Antichrist.hello() == :world
  end
end
