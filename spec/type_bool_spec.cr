require "./spec_helper"

private class MyClass
  var foo : Bool = false
end

describe "var foo : Bool = false  # TypeDeclaration" do
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
