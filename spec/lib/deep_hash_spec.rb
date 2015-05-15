require "deep_hash"

describe DeepHash, "#dig" do
  it "returns the value if its there" do
    hash = DeepHash.new(
      foo: {
        bar: {
          baz: {
            qux: "value",
          },
        },
      },
    )

    expect(hash.dig(:foo, :bar, :baz)).to eq(qux: "value")
    expect(hash.dig(:foo, :bar, :baz, :qux)).to eq "value"
  end

  it "returns nil if the chain of keys fails along the way" do
    hash = DeepHash.new({})

    expect(hash.dig(:foo, :bar, :baz)).to be_nil
  end
end
