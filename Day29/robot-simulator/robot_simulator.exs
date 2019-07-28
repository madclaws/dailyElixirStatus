defmodule RobotSimulator do
  use GenServer

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  ###########################################################################
  #  Client functions(basically called by the client process, here iex)

  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})
  def create(direction, _position) when direction not in [:north, :south, :east, :west] do
    {:error, "invalid direction"}
  end
  def create(direction, {x, y}) when is_number(x) and is_number(y) do
    robot_init_state = %{direction: direction, position: {x, y}}
    #  Creating a new simulator process by the client with the inital robot state
    {:ok, robot_id} = GenServer.start_link(__MODULE__, robot_init_state,[])
    # Returning the process id of simulator
    robot_id
  end
  def create(_, _) , do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    # calling simulator process to run the simulation with the given instructions from client.
    GenServer.call(robot, {:simulate, instructions})
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    #  calling simulator process to get the current direction
    GenServer.call(robot, :direction)
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    # calling simulator process to get the current position
    GenServer.call(robot, :position)
  end

  ###########################################

  # Server functions (the callback functions of its client counterparts)

  @impl true
  def init(init_state) do
    {:ok, init_state}
  end

  @impl true
  def handle_call({:simulate, instructions}, _from, robot_state) do
    case simulate_robot(instructions, robot_state) do
      :error -> {:reply, {:error, "invalid instruction"}, robot_state}
      new_robot_state -> {:reply, self(), new_robot_state}
    end
  end

  def handle_call(:direction, _from, robot_state) do
    {:reply, robot_state.direction, robot_state}
  end
  def handle_call(:position, _from, robot_state) do
    {:reply, robot_state.position, robot_state}
  end

  # Entry Code that simulates / validates the instructions
  defp simulate_robot(instructions, robot_state) do
    instruction_set = String.codepoints(instructions)
    case is_valid?(instruction_set) do
      true -> String.codepoints(instructions)
              |> Enum.reduce(robot_state, fn instruction, updated_robot_state ->
              simulator(instruction, updated_robot_state)
            end)
      false -> :error
    end
  end

  # Helper functions for simulation
  defp simulator(instruction, robot_state)
  defp simulator("R", robot_state), do: %{robot_state | direction: rotate("R", robot_state.direction)}
  defp simulator("L", robot_state), do: %{robot_state | direction: rotate("L", robot_state.direction)}
  defp simulator("A", robot_state), do: %{robot_state | position: advance(robot_state.position, robot_state.direction)}

  defp is_valid?(instructions), do: Enum.all?(instructions, fn command -> command in ["R", "L", "A"] end)

  def rotate("R", current_direction) do
    case current_direction do
      :north -> :east
      :south -> :west
      :west ->  :north
      :east ->  :south
    end
  end
  def rotate("L", current_direction) do
    case current_direction do
      :north -> :west
      :south -> :east
      :west ->  :south
      :east ->  :north
    end
  end

  def advance({x, y}, current_direction) do
    case current_direction do
      :north -> {x, y + 1}
      :east ->  {x + 1, y}
      :south -> {x, y - 1}
      :west ->  {x - 1, y}
    end
  end

end
