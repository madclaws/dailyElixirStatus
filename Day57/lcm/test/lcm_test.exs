defmodule LcmTest do
  use ExUnit.Case
  doctest Lcm

  test "hcf1" do
    assert Lcm.hcf(6, 9) === 3
  end
  test "hcf2" do
    assert Lcm.hcf(14, 18) === 2
  end
  test "hcf3" do
    assert Lcm.hcf(15, 10) === 5
  end

  test "lcm1" do
    assert Lcm.lcm(16, 20) === 80
  end


  test "lcm2" do
    assert Lcm.lcm(15, 25) === 75
  end

end
