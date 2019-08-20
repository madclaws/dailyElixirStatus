defmodule ContractorTest do
  use ExUnit.Case
  doctest Contractor

  test "greets the world" do
    assert Contractor.hello() == :world
  end
end
