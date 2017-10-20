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
    __var_with_type__({{name.type.stringify.gsub(/ \| ::Nil/, "").id}}, {{name}})
  end

  # ```
  # TypeDeclaration
  #   def var : MacroId
  #   def type : ASTNode
  #   def value : ASTNode | Nop
  # ```
  private macro __var_with_type__(type, name)
    @{{name.var.id}} : ::Var({{type}}) = ::Var({{type}}).new(name: {{name.var.stringify}}, born: {{__FILE__}} + ":{{__LINE__}}", value: {{name.value.stringify.gsub(/\A\Z/, "nil").id}})

    {% if name.type.stringify =~ / \| ::Nil/ %}
    def {{name.var.id}} : {{name.type}}
      @{{name.var.id}}.get?
    end
    {% else %}
    def {{name.var.id}} : {{type}}
      @{{name.var.id}}.get
    end
    {% end %}

    {% if name.type.stringify == "Bool" %}
    def {{name.var.id}}? : Bool
      @{{name.var.id}}.get
    end
    {% else %}
    def {{name.var.id}}? : {{type}}?
      @{{name.var.id}}.get?
    end
    {% end %}

    def {{name.var.id}}=(v : {{type}}) : {{type}}
      @{{name.var.id}}.value = v
    end
  end
end
