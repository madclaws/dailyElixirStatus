defmodule Worker do

  def get_weather(location) do
    result = location |> url_for |> HTTPoison.get |> parse_response
    case result do
      {:ok, temperature} -> "the temperature at #{location} is #{temperature}"
      :error -> "What on earth is that place "
    end
  end

  defp  uri_encode(location) do
    URI.encode(location)
  end

  def url_for(location) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{uri_encode(location)}&appid=#{api_key()}"
  end

  defp api_key do
    "2f7026ea6fc900f3ba57acbb87c5994e"
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: content}}) do
    content |> JSON.decode! |> compute_temp
  end

  defp parse_response(_), do: :error

  defp compute_temp(json_data) do
    try do
      temp = json_data["main"]["temp"] - 273.15
      {:ok, temp}
    rescue
    _ -> :error
    end
  end
end
