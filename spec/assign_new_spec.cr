require "./spec_helper"

private class Foo
  def initialize(parent)
    parent.cnt += 1
  end
end

private class MyClass
  var foo = Foo.new(self)
  var cnt = 0
end

describe "var foo = Foo.new" do
  it "evaluates lazily" do
    obj = MyClass.new
    obj.cnt.should eq(0)
    obj.foo.should be_a(Foo)
    obj.cnt.should eq(1)
  end
end
