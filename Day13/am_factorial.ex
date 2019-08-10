defmodule AMFactorial do

  def fac(num, fac \\ 1)
  def fac(num, acc ) when num == 1 do
    acc
  en

  def fac(num, acc) when num > 1 do
    fac(num - 1,num * acc)
  end

  def fac(_, _), do: "bc"

