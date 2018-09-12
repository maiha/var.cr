require "./spec_helper"

private class MyClass
  var foo = true
  var bar = 1
  var baz = "a"
  var qux = ["a"]
end

describe "var foo = true  # Assign(BoolLiteral)" do
  obj = MyClass.new

  describe "foo, foo?" do
    it "returns true" do
      obj.foo.should eq(true)
      obj.foo?.should eq(true)
    end
  end

  describe "foo = false" do
    it "returns false" do
      obj.foo = false
      obj.foo.should eq(false)
      obj.foo?.should eq(false)
    end
  end
end

describe "var bar = 1  # Assign(NumberLiteral)" do
  obj = MyClass.new

  describe "bar, bar?" do
    it "returns 1" do
      obj.bar.should eq(1)
      obj.bar?.should eq(1)
    end
  end

  describe "bar = 2" do
    it "returns 2" do
      obj.bar = 2
      obj.bar.should eq(2)
      obj.bar?.should eq(2)
    end
  end
end

describe "var baz = \"a\"  # Assign(StringLiteral)" do
  obj = MyClass.new

  describe "baz, baz?" do
    it "returns \"a\"" do
      obj.baz.should eq("a")
      obj.baz?.should eq("a")
    end
  end

  describe "baz = \"b\"" do
    it "returns \"b\"" do
      obj.baz = "b"
      obj.baz.should eq("b")
      obj.baz?.should eq("b")
    end
  end
end

describe "var qux = [\"a\"]  # Assign(ArrayLiteral)" do
  obj = MyClass.new

  describe "qux" do
    it "returns [\"a\"]" do
      obj.qux.should eq(["a"])
    end
  end
  
  describe "qux = [\"b\"]" do
    pending "(It seems ArrayLiteral, but we can't know the generics type in macro)" do
      obj.baz = ["b"]
      obj.baz.should eq(["b"])
      obj.baz?.should eq(["b"])
    end
  end
end
