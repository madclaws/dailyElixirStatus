defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @events %{
    0 => "wink",
    1 => "double blink",
    2 => "close your eyes",
    3 => "jump"
  }


  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    create_handshake(code)
  end

  defp create_handshake(code, event_list \\ [], count \\ 0)

  defp create_handshake(0, event_list, _count), do: event_list
  defp create_handshake(code, event_list, count) when count === 4 do
    create_handshake(div(code, 2), Enum.reverse(event_list), count + 1)
  end
  defp create_handshake(_, event_list, count) when count === 5 , do: event_list
  defp create_handshake(code, event_list, count) do
    case rem(code, 2) do
      1 -> create_handshake(div(code, 2), event_list ++ [@events[count]], count + 1)
      _ -> create_handshake(div(code, 2), event_list, count + 1)
    end
  end

end
