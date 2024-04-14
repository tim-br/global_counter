defmodule GlobalCounterTest do
  use ExUnit.Case
  doctest GlobalCounter

  test "greets the world" do
    assert GlobalCounter.hello() == :world
  end
end
