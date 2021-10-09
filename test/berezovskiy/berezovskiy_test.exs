defmodule BerezovskiyTest do
  use ExUnit.Case
  doctest Berezovskiy

  test "greets the world" do
    assert Berezovskiy.hello() == :world
  end
end
