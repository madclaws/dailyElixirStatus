defmodule Cache do
  alias Cache.Core.Memory
  def init() do
    Memory.start_link()
  end

  def write(key, value) do
    Memory.write({key, value})
  end

  def read(key) do
    Memory.read(key)
  end

  def delete(key) do
    Memory.delete(key)
  end

  def clear() do
    Memory.clear()
  end

  def exist?(key) do
    Memory.exist(key)
  end
end
