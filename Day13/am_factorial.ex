defmodule AMFactorial do

  def fac(num, acc) when num == 1 do
    acc
  end

  def fac(num, acc) do
    fac(num - 1,num * acc)
  end
