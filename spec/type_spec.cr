require "./spec_helper"

private class MyClass
  var foo : String

  def read_ivar_foo
    @foo
  end
end

describe "var foo : String  # TypeDeclaration" do
  describe "@foo" do
    it "is a Var(String)" do
      obj = MyClass.new
      obj.read_ivar_foo.should be_a(Var(String))
    end
  end

  context "(without initialization)" do
    obj = MyClass.new

    describe "foo?" do
      it "returns nil" do
        obj.foo?.should eq(nil)
      end
    end

    describe "foo" do
      it "raises `Var::NotReady`" do
        expect_raises(Var::NotReady, /foo/) { obj.foo }
      end
    end
  end

  context "(foo = \"a\")" do
    obj = MyClass.new
    obj.foo = "a"

    describe "foo?" do
      it "returns \"a\"" do
        obj.foo?.should eq("a")
      end
    end

    describe "foo" do
      it "returns \"a\"" do
        obj.foo?.should eq("a")
      end
    end
  end
end
