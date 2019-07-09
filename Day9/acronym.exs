defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    String.split(string, [","," ","-"], trim: true)
    |> Enum.reduce("", fn word, acc -> acc <> generate_acronym(String.next_codepoint(word)) end)
  end

  def generate_acronym({first, rest}) do
    acronym_from_rest = String.codepoints(rest)
      |> Enum.filter(fn letter -> letter !== String.downcase(letter) end)
      |> List.to_string
    String.upcase(first <> acronym_from_rest)
  end
end
