defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"ability" => "a", "aardvark" => "a", "ballast" => "b", "beauty" =>"b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    Enum.reduce(input, %{}, fn {key, value}, inverted_etl_map ->
      Enum.reduce(value, inverted_etl_map, fn item, inverted_etl_map ->
        put_in inverted_etl_map[String.downcase(item)], key
      end)
    end)
  end
end
