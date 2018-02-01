require "./spec_helper"

private class MyClass
  var foo : Int32 = build_foo

  private def build_foo
    1
  end
end

describe "var foo = build  # Assign" do
  obj = MyClass.new

  describe "foo" do
    it "returns 1" do
      obj.foo.should eq(1)
    end
  end
end
