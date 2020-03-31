defmodule LinkedList do
  require Logger
  use Agent
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new() do
    # the return tuple should contain header of linked list.
    {:ok, nil}
  end

  @doc """
  Push an item onto a LinkedList

  Returns the header
  """
  @spec push(t, any()) :: t
  def push(header, elem) do
		new_node_ptr = create_new_node(elem)
		case header do
      {:ok, nil} -> {:ok, new_node_ptr}
			{:ok, header} ->
				:ok = get_node(header)
							|> push_to_linked_list(new_node_ptr, header)
				{:ok, header}
			_ -> {:error, "invalid"}
    end
  end

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length(header, count \\ 0)
  def length({_val, nil}, count), do: count
  def length({_val, next_ptr}, count) do
    length(get_node(next_ptr), count + 1)
  end

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?({:ok, nil}), do: true
  def empty?(_), do: false

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({:ok, header_ptr}) do
    case get_node(header_ptr) do
      {val, _next_ptr} -> {:ok, val}
      _ -> {:error, :empty_list}
    end
  end

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({:ok, nil}), do: {:error, :empty_list}
  def tail({val, nil}), do: {:ok, val}
  def tail({_val, ptr}) do
    tail(get_node(ptr))
  end

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({:ok, nil}), do: {:error, :empty_list}
  def pop({:ok, head_ptr}) do
    {val, next_ptr} = get_node(head_ptr)
    Agent.stop(head_ptr)
    Logger.info("#{val} is popped..")
    {:ok, next_ptr}
  end
  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list) do
    Enum.reduce(list, {:ok, nil}, fn element, linked_list ->
        push(linked_list, element)
    end)
  end

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list, stdlib_list \\ [])
  def to_list({:ok, nil}, _stdlib_list), do: []
  def to_list({:ok, next_ptr}, _stdlib_list), do: to_list(get_node(next_ptr), [])
  def to_list({val, nil}, stdlib_list), do: stdlib_list ++ [val]
  def to_list({val, next_ptr}, stdlib_list) do
    to_list(get_node(next_ptr), stdlib_list ++ [val])
  end


  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list, prev_ptr \\ nil)
  def reverse({_val, nil}, prev_ptr), do: {:ok, prev_ptr}
  def reverse({_val, block_ptr}, prev_ptr) do
    {val, next_ptr} = get_node(block_ptr)
    Agent.update(block_ptr, fn _ -> {val, prev_ptr} end)
    reverse({val, next_ptr}, block_ptr)
  end

	defp create_new_node(element) do
		{:ok, node_ptr} = Agent.start_link(fn  -> {element, nil} end)
    node_ptr
  end


  defp push_to_linked_list(node, new_node_ptr, current_node_ptr)
  defp push_to_linked_list({val, nil}, new_node_ptr, current_node_ptr) do
    Agent.update(current_node_ptr, fn _ -> {val, new_node_ptr} end)
  end

  defp push_to_linked_list({_val, next_node_ptr}, new_node_ptr, current_node_ptr) do
		get_node(current_node_ptr)
		|> push_to_linked_list(new_node_ptr, next_node_ptr)
  end

  defp get_node(nil), do: :error
  defp get_node(node_ptr) do
    Agent.get(node_ptr, fn node -> node end)
  end
end
