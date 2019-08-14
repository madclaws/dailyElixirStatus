defmodule ArmstrongNumberTest do
  use ExUnit.Case
  doctest ArmstrongNumber

  test "single digit armstrong number" do
    assert ArmstrongNumber.is_armstrong_number?(3)
  end

  test "3 digit armstrong number" do
    assert ArmstrongNumber.is_armstrong_number?(153)
  end

  test "Again 3 digit armstrong number" do
    assert ArmstrongNumber.is_armstrong_number?(371)
  end

  test "not an armstrong number" do
    refute ArmstrongNumber.is_armstrong_number?(29)
  end

end
