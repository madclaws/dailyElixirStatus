defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}
  require Logger
  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    # Your implementation here
    %{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(nil, data), do: new(data)
  def insert(%{data: data, left: left, right: right}, node_value) when node_value <= data do
    %{data: data, left: insert(left, node_value), right: right}
  end
  def insert(tree, node_value) do
    %{
      tree | right: insert(tree.right, node_value)
    }
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(nil), do: []
  def in_order(tree) do
    # Your implementation here
      in_order(tree.left) ++ [tree.data] ++ in_order(tree.right)
  end
end
