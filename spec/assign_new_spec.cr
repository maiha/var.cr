require "./spec_helper"

private class Foo
  def initialize(parent)
    parent.foo_created_cnt += 1
  end
end

private class MyClass
  var counts = Hash(String, Int32).new

  var foo = Foo.new(self)
  var foo_created_cnt = 0
end

describe "var foo = Foo.new" do
  it "works with Hash.new" do
    obj = MyClass.new
    obj.counts["a"] = 1
    obj.counts.should eq({"a" => 1})
  end

  it "builds an instance lazily and exactly once" do
    obj = MyClass.new
    obj.foo_created_cnt.should eq(0)
    obj.foo.should be_a(Foo)
    obj.foo_created_cnt.should eq(1)
    obj.foo
    obj.foo_created_cnt.should eq(1)
  end
end
