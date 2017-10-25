require "./spec_helper"

private class MyClass
  var foo = 1 + 2
end

describe "var foo = 1 + 2  # Assign" do
  obj = MyClass.new

  describe "foo" do
    it "returns 3" do
      obj.foo.should eq(3)
    end
  end
end
