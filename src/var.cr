module Var
  class NotReady < Exception
  end

  def self.not_ready(name, born)
    raise NotReady.new("var `#{name}` is not set yet. (Defined in '#{born}')")
  end
end

class Object
  # `var(TypeDeclaration)`
  #
  # I don't know how to get `String` from `String?` in macro.
  # So, first we convert it in String level, and then call another macro.
  #
  # ```
  # var foo : String? = nil
  # __var_with_type__ String, foo : String? = nil
  # ```
  macro var(name)    
    {% if name.is_a?(TypeDeclaration) %}
      __var_with_type__({{name.filename}} + ":{{name.line_number}}", {{name.type.stringify.gsub(/ \| ::Nil/, "").id}}, {{name.var}}, {{name.value.stringify}}, {{name.type}})
    {% elsif name.is_a?(Assign) %}
      {% if name.value.class_name =~ /NumberLiteral$/ %}
        __var_with_assign_type__({{name.filename}} + ":{{name.line_number}}", Int32, {{name.target}}, {{name.value}})
      {% elsif name.value.class_name =~ /(Array|Hash)Literal$/ %}
        __var_with_assign_unknown_type__({{name}})
      {% elsif name.value.class_name =~ /Literal$/ %}
        __var_with_assign_type__({{name.filename}} + ":{{name.line_number}}", {{name.value.class_name.gsub(/Literal$/, "").id}}, {{name.target}}, {{name.value}})
      {% elsif name.value.class_name == "Call" && name.value.name.stringify == "new" %}
        # var foo = Foo.new(self)
        # [name.value.id  ] Foo.new(self)
        # [name.value.name] new
        # [name.value.id.stringify.gsub(/\.new\b.*$/, "")] "Foo"
        __var_with_assign_type__({{name.filename}} + ":{{name.line_number}}", {{name.value.id.stringify.gsub(/\.new\b.*$/, "").id}}, {{name.target}}, {{name.value}})
      {% else %}
        __var_with_assign_unknown_type__({{name}})
      {% end %}
    {% else %}
      {% abort "var.cr doesn't support " + name.class_name %}
    {% end %}
  end

  # ```
  # TypeDeclaration
  #   def var : MacroId
  #   def type : ASTNode
  #   def value : ASTNode | Nop
  # ```
  private macro __var_with_type__(clue, type, name, value, original_type)
    # [crystal]              # {{value}}
    # var foo : String       # ""
    # var var : String = nil # "nil"
    # var baz : String = ""  # "\"\""
    @{{name.id}} : {{type}}? = nil

    private def __build_{{name.id}}
      {% if value == "" %}
        Var.not_ready({{name.stringify}}, {{clue}})
      {% elsif original_type.stringify =~ / \| ::Nil/ %}
        {{value.id}}
      {% else %}
        {{value.id}}
      {% end %}
    end
                             
    {% if original_type.stringify =~ / \| ::Nil/ %}
    def {{name.id}} : {{original_type}}
      @{{name.id}} ||= __build_{{name.id}}
    end
    {% else %}
    def {{name.id}} : {{type}}
      # don't use "||=" for Bool cases
      if @{{name.id}} == nil
        @{{name.id}} = __build_{{name.id}}
      end
      {% if type.stringify == "Bool" %}
        !! @{{name.id}}
      {% else %}
        @{{name.id}} || Var.not_ready({{name.stringify}}, {{clue}})
      {% end %}
    end
    {% end %}

    {% if type.stringify == "Bool" %}
    def {{name.id}}? : Bool
      {{name.id}}
    end
    {% else %}
    def {{name.id}}? : {{type}}?
      {% if value == "" %}
        return @{{name.id}}
      {% else %}
        @{{name.id}} ||= __build_{{name.id}}
      {% end %}
    end
    {% end %}

    def {{name.id}}=(v : {{type}}) : {{type}}
      @{{name.id}} = v
    end

    # `nil` assignments are always ignored
    def {{name.id}}=(v : Nil)
    end
  end

  # ```
  # class Assign < ASTNode
  #   def target : ASTNode
  #   def value : ASTNode
  # ```
  private macro __var_with_assign_type__(clue, type, name, value)
    __var_with_type__({{clue}}, {{type}}, {{name}}, {{value.stringify}}, {{type}})
  end

  private macro __var_with_assign_unknown_type__(name)
    def {{name.target.id}}
      {{name.value}}
    end
  end
end
