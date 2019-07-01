defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(input) do
    str_list = to_rna2(input)
    Enum.concat(str_list)
    # to_rna2(input)

  end
  def to_rna2([]) do
    []
  end
  def to_rna2([_h = ?A | rest_string]) do
    ['U' | to_rna(rest_string)]
  end
  def to_rna2([_h = ?T | rest_string])  do
    ['A' | to_rna(rest_string)]
  end
  def to_rna2([_h = ?C | rest_string]) do
    ['G' | to_rna(rest_string)]
  end
  def to_rna2([_h = ?G | rest_string]) do
    ['C' | to_rna(rest_string)]
  end
end

