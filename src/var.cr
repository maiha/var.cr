require "./var/*"

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
      __var_with_type__({{name.type.stringify.gsub(/ \| ::Nil/, "").id}}, {{name.var}}, {{name.value.stringify.gsub(/\A\Z/, "nil").id}}, {{name.type}})
    {% elsif name.is_a?(Assign) %}
      {% if name.value.class_name =~ /NumberLiteral$/ %}
        __var_with_assign_type__(Int32, {{name.target}}, {{name.value}})
      {% elsif name.value.class_name =~ /(Array|Hash)Literal$/ %}
        __var_with_assign__({{name}})
      {% elsif name.value.class_name =~ /Literal$/ %}
        __var_with_assign_type__({{name.value.class_name.gsub(/Literal$/, "").id}}, {{name.target}}, {{name.value}})
      {% else %}
        __var_with_assign__({{name}})
      {% end %}
    {% end %}
  end

  # ```
  # TypeDeclaration
  #   def var : MacroId
  #   def type : ASTNode
  #   def value : ASTNode | Nop
  # ```
  private macro __var_with_type__(type, name, value, original_type)
    @{{name.id}} : ::Var({{type}}) = ::Var({{type}}).new(name: {{name.stringify}}, born: {{__FILE__}} + ":{{__LINE__}}", value: {{value}})

    {% if original_type.stringify =~ / \| ::Nil/ %}
    def {{name.id}} : {{original_type}}
      @{{name.id}}.get?
    end
    {% else %}
    def {{name.id}} : {{type}}
      @{{name.id}}.get
    end
    {% end %}

    {% if type.stringify == "Bool" %}
    def {{name.id}}? : Bool
      @{{name.id}}.get
    end
    {% else %}
    def {{name.id}}? : {{type}}?
      @{{name.id}}.get?
    end
    {% end %}

    def {{name.id}}=(v : {{type}}) : {{type}}
      @{{name.id}}.value = v
    end
  end

  # ```
  # class Assign < ASTNode
  #   def target : ASTNode
  #   def value : ASTNode
  # ```
  private macro __var_with_assign_type__(type, name, value)
    __var_with_type__({{type}}, {{name}}, {{value}}, {{type}})
  end

  private macro __var_with_assign__(name)
    def {{name.target.id}}
      {{name.value}}
    end
  end
end
