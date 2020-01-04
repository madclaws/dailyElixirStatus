defmodule BinaryTree do
  @moduledoc """
    Functions to create and modify Binary tree.
  """

	defstruct [data: nil, left: nil, right: nil]
	def create_node(data \\ nil) do
		%{data: data, left: nil, right: nil}
	end

	def add_node(nil, value) do
		%{
			data: value,
			left: nil,
			right: nil
		}
	end

	def add_node(%{data: data, left: left, right: right}, value) when value > data do
		%{data: data, left: left, right: add_node(right, value)}
	end
	def add_node(%{data: data, left: left, right: right}, value) when value <= data do
		%{data: data, left: add_node(left, value), right: right}
	end

end
