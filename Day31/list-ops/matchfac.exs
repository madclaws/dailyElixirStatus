defmodule MatchstickFactory do
  def boxes(num) do
    %{"big" => div(num,50),
    "medium" => rem(num,50) |> div(20),
    "remaining" => rem(num,50) |> rem(20) |> rem(5),
     "small" => rem(num,50) |> rem(20) |> div(5)
    }
  end
end
