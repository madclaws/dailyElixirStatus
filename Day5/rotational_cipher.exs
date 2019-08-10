defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    String.to_charlist(text)
      |> Enum.map(&rotating_character(&1, shift))
      |> List.to_string()
  end

  def rotating_character(char, shift) do
    case char do
      char when char > 64 and char < 91 -> cond do
        char + shift > 90 -> ((char + shift) - 90) + 64
        true -> char + shift
      end
      char when char > 96 and char <= 122 -> cond do
        char + shift > 122 -> ((char + shift) - 122) + 96
        true -> char + shift
      end
      _ -> char
    end
  end
end
