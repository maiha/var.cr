require "./spec_helper"

private class App1
  var id  : Int32 = 0
  var s   : String
  var sd  : String = "a"
  var hd  : Hash(String, String) = Hash(String, String).new
  var snd : String? = nil
  var b   : Bool
  var bd  : Bool = false
end

describe "Var" do
  context "(without default)" do
    it "should raise" do
      expect_raises(Var::NotReady, /var `s` is not set yet.*basic_spec\.cr:5/) { App1.new.s }
      expect_raises(Var::NotReady, /var `b` is not set yet.*basic_spec\.cr:9/) { App1.new.b }
    end
  end

  context "(with default)" do
    it "Int32" do
      App1.new.id.should eq(0)
    end

    it "Hash(String, String)" do
      App1.new.hd.should eq(Hash(String, String).new)
    end

    it "String" do
      App1.new.sd.should eq("a")
    end

    it "String?" do
      App1.new.snd.should eq(nil)
    end

    it "Bool" do
      App1.new.bd.should eq(false)
    end
  end
end
