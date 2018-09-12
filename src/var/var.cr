class Var(T)
  class NotReady < Exception
  end

  def self.not_ready(name, born)
    raise NotReady.new("var `#{name}` is not set yet. (Defined in '#{born}')")
  end
end
