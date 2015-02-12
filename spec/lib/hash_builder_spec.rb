require "active_support/all"
require "hash_builder"

describe HashBuilder do
  it "quickly assigns stuff to a hash" do
    hash = HashBuilder.new
    hash.foo = :foo
    hash.bar = :bar

    expect(hash.foo).to eq :foo
    expect(hash.bar).to eq :bar
  end

  it "converts the hash to json" do
    hash = HashBuilder.new
    hash.foo = :foo
    hash.bar = :bar

    expect(hash.as_json).to eq({"foo"=>"foo", "bar"=>"bar"})
  end

  it "allows easy creation of nested hashes" do
    hash = HashBuilder.new
    hash.one.two.three.four = :foo

    expect(hash.one.two.three.four).to eq :foo
    expect(hash.as_json).to eq({"one"=>{"two"=>{"three"=>{"four"=>"foo"}}}})
  end
end
