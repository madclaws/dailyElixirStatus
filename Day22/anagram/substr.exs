defmodule SubStringCheck do
  @doc """
  Simply returns "Hello, World!"
  """

  def check do
    a = IO.gets("String 1: ")
    b = IO.gets("String 2: ")

    if a =~ b do
      IO.puts "String 2 is subset of string 1."
    else
      IO.puts "String 2 is not a subset of string 1."
    end

  end

end
SubStringCheck.check()
