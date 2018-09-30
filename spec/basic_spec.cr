require "./spec_helper"

private class App
  var id  : Int32 = 0
  var s   : String
  var sd  : String = "a"
  var hd  : Hash(String, String) = Hash(String, String).new
  var sn  : String?
  var snd : String? = nil
  var b   : Bool
  var bd  : Bool = false
end

describe "var" do
  context "(without default)" do
    it "should raise" do
      expect_raises(Var::NotReady, /var `s` is not set yet.*basic_spec\.cr:5/) { App.new.s }
      expect_raises(Var::NotReady, /var `b` is not set yet.*basic_spec\.cr:10/) { App.new.b }
    end
  end

  context "(with default)" do
    it "provides default values" do
      obj = App.new
      obj.id.should eq(0)
      obj.hd.should eq(Hash(String, String).new)
      obj.sd.should eq("a")
      obj.snd.should eq(nil)
      obj.bd.should eq(false)
    end
  end

  describe "nil assignments" do
    it "is always ignored" do
      obj = App.new

      obj.id = nil
      obj.id.should eq(0)

      obj.hd = nil
      obj.hd.should eq(Hash(String, String).new)

      obj.sd = nil
      obj.sd.should eq("a")

      obj.snd = nil
      obj.snd.should eq(nil)

      obj.bd = nil
      obj.bd.should eq(false)
    end
  end
end
