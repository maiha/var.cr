require "./spec_helper"

private class MyClass
  var foo : Bool = false

  def read_ivar_foo
    @foo
  end
end

describe "var foo : Bool = false  # TypeDeclaration" do
  describe "@foo" do
    it "is a Var(String)" do
      obj = MyClass.new
      obj.read_ivar_foo.should be_a(Var(Bool))
    end
  end

  context "(default)" do
    obj = MyClass.new

    describe "foo?" do
      it "returns false" do
        obj.foo?.should eq(false)
      end
    end

    describe "foo" do
      it "returns false" do
        obj.foo.should eq(false)
      end
    end
  end

  context "(foo = true)" do
    obj = MyClass.new
    obj.foo = true

    describe "foo?" do
      it "returns true" do
        obj.foo?.should eq(true)
      end
    end

    describe "foo" do
      it "returns true" do
        obj.foo?.should eq(true)
      end
    end
  end
end
