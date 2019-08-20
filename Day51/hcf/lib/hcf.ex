  defmodule Hcf do

    def find(num1, num2) when num1 === num2, do: num1

    def find(num1, num2) when num1 > num2, do: find(num1 - num2, num2)
    def find(num1, num2) when num2 > num1, do: find(num1, num2 - num1)
  end
