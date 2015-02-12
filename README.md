# Tonsser Hash Utils

A collection of classes for dealing with hashes. We've found them to be useful when manipulating a lot of JSON.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "tonsser_hash_utils", "~> 1.0"
```

And then execute:

```
bundle install
```

Or install it yourself as:

```
gem install tonsser_hash_utils
```

## Usage

The gem contains the following classes

- `HashWithQuickAccess`
- `DeepHash`
- `HashMerger`
- `HashBuilder`

### HashWithQuickAccess

`HashWithQuickAccess` makes it easy to access lots of properties within deeply nested hashes. Useful when dealing with hashes that are serialized from JSON.

Example:

```ruby
# This
json[:foo][:bar][:baz][:qux]

# Becomes this
hash = HashWithQuickAccess.new(json)
hash.foo.bar.baz.qux
```

It also supports arrays within the hashes, so you can do stuff like

```ruby
hash = HashWithQuickAccess.new(json)
hash.foo.bar[4].baz.qux
```

### DeepHash

`DeepHash` is useful for checking if some deeply nested value is present.

Example:

```ruby
# This
params[:foo] && params[:foo][:bar] && params[:foo][:bar][:baz]

# Becomes this
DeepHash.new(params).dig(:foo, :bar, :baz)
```

### HashMerger

`HashMerger` is useful for recursively deep merging hashes that can contains arrays, which should also be merged.

Example:

```ruby
one = {
  foo: {
    bar: [1,2,3]
  }
}

two = {
  foo: {
    bar: [4,5]
    qux: "Yo!"
  }
}

HashMerger.new(one).merge_with(two) # => {
                                    #      foo: {
                                    #        bar: [1,2,3,4,5],
                                    #        qux: "Yo!"
                                    #      }
                                    #    }
```

**NOTE**: The merging is done using recursion, which might overflow the stack in Ruby due to the lack of tail call optimization. This shouldn't be a problem unless you have giant hashes, but be aware!

### HashBuilder

`HashBuilder` is useful for building a hash that might contain deep nesting.

```ruby
# This
json = {
  one: {
    two: {
      three: {
        four: :foo
      }
    }
  }
}

# Becomes this
builder = HashBuilder.new
builder.one.two.three.four = :foo
json = builder.as_json
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tonsser_hash_utils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
