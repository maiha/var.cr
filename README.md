# var.cr [![Build Status](https://travis-ci.org/maiha/var.cr.svg?branch=master)](https://travis-ci.org/maiha/var.cr)

`var` provides a macro that gives a lazy evaluation to the `property` variable.
Users are freed from ugly `not_nil!` and tired `not initialized` constraints
and can write simple code.

- [tested versions](./ci)

## Usage

```crystal
require "var"

class Sample
  var foo = true
  var bar : Int32 = build_bar
  var baz : String
  var counts = Hash(String, Int32).new

  private def build_bar
    1
  end
end

obj = Sample.new
obj.foo?      # => true
obj.foo       # => true
obj.bar?      # => 1
obj.bar       # => 1
obj.baz?      # => nil
obj.baz       # raises "var `baz` is not set yet." (Var::NotReady)
obj.baz = "a"
obj.baz       # => "a"

obj.baz = nil # `nil` assignments are always ignored
obj.baz       # => "a"

obj.counts["a"] = 1
obj.counts    # => {"a" => 1}
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  var:
    github: maiha/var.cr
    version: 1.2.0
```

## Development

```shell
make ci
```

## Contributing

1. Fork it ( https://github.com/maiha/var.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
