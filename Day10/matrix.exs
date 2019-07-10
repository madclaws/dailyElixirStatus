defmodule Matrix do
  defstruct matrix: nil

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    %{matrix: String.split(input, ["\n"])
    |> Enum.map(fn row -> String.split(row)
    |> Enum.map(fn item -> String.to_integer(item) end) end)}
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(%{matrix: matrix}) do
    Enum.reduce(matrix, "", fn row, acc -> acc <> row_to_string(row) end)
      |> String.trim_trailing
  end

  def row_to_string(row) do
    Enum.reduce(row, "", fn item, acc -> acc <> Integer.to_string(item) <> " " end)
    |> String.replace_trailing(" ", "\n")
  end
  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(%{matrix: matrix}) do
    matrix
  end

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(%{matrix: matrix}, index) do
    Enum.fetch!(matrix, index)
  end

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(%{matrix: matrix}) do
    for x <- 0..2, do: Enum.map(matrix, fn row -> Enum.fetch!(row, x) end)
  end

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(%{matrix: matrix}, index) do
    columns(%{matrix: matrix}) |> Enum.fetch!(index)
  end
end
