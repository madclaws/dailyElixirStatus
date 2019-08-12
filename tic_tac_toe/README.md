# Day 43 |> Multiplayer TicTacToe with OTP

** This is a multiplayer tictactoe module which can be plugged to a phoenix socket application.
**

## Testing
You can run the test by
```Elixir
mix test
```

You can also load the module in an iex like
```
iex -S mix
```
then run ```TicTacToe.start_simulation``` which will run a simple simulation

Or You can load via iex and then give commands one by one and play the game.

** This application doesnt have any UI support **

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tic_tac_toe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tic_tac_toe, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tic_tac_toe](https://hexdocs.pm/tic_tac_toe).

