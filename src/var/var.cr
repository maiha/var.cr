class Var(T)
  class NotReady < Exception
    def initialize(var)
      super("var `#{var.name}` is not set. (Defined in '#{var.born}')")
    end
  end

  enum State
    Unset
    Bound
  end

  ######################################################################
  ### Properties

  getter state
  getter name
  getter born

  property builder : Proc(T)

  ######################################################################
  ### Instance creation

  def initialize(@state : State, @name : String, @born : String, @value : T? = nil, builder : Proc(T)? = nil)
    @builder = builder || Proc(T).new{ not_found }
  end

  def self.new(name : String, born : String)
    new(State::Unset, name, born)
  end

  def self.new(name : String, born : String, value : T?)
    new(State::Bound, name, born, value)
  end

  ######################################################################
  ### Accessor methods

  delegate bound?, unset?, to: @state
  
  def get? : T?
    if unset?
      @value = @builder.call
      @state = State::Bound
    end

    return @value
  end

  def get : T
    v = get?
    if v.is_a?(T)               # use `is_a?` for Bool
      return v
    else
      not_found
    end
  end

  def value=(v : T) : T
    @value = v
  end

  def value? : T?
    @value
  end

  protected def not_found : T
    raise NotReady.new(self)
  end
end
