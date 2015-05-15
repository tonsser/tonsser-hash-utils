require "hash_merger"

describe HashMerger do
  it "deep merges hashes" do
    a = {
      foo: {
        bar: {
          baz: "one",
        },
        yo: "yo",
      },
      yo: "yo",
    }

    b = {
      foo: {
        bar: {
          qux: "two",
        },
      },
      dog: "dog",
    }

    merged = HashMerger.new(a).merge_with(b)

    expect(merged).to eq(
      foo: {
        bar: {
          baz: "one",
          qux: "two",
        },
        yo: "yo",
      },
      yo: "yo",
      dog: "dog",
    )

    expect(a).to eq(
      foo: {
        bar: {
          baz: "one",
        },
        yo: "yo",
      },
      yo: "yo",
    )

    expect(b).to eq(
      foo: {
        bar: {
          qux: "two",
        },
      },
      dog: "dog",
    )
  end

  it "deep merges arrays" do
    a = {
      foo: {
        bar: ["one"],
      },
    }

    b = {
      foo: {
        bar: ["two"],
      },
    }

    merged = HashMerger.new(a).merge_with(b)

    expect(merged).to eq(foo: { bar: ["one", "two"] })
    expect(a).to eq(foo: { bar: ["one"] })
    expect(b).to eq(foo: { bar: ["two"] })
  end

  it "merges hashes with mixed types" do
    a = {
      foo: {
        bar: {
          baz: "one",
        },
        array: [1, 2],
        yo: "yo",
      },
      yo: "yo",
    }

    b = {
      foo: {
        bar: {
          qux: "two",
        },
        array: [3, 4],
      },
      dog: "dog",
    }

    merged = HashMerger.new(a).merge_with(b)

    expect(merged).to eq(
      foo: {
        bar: {
          baz: "one",
          qux: "two",
        },
        array: [1, 2, 3, 4],
        yo: "yo",
      },
      yo: "yo",
      dog: "dog",
    )

    expect(a).to eq(
      foo: {
        bar: {
          baz: "one",
        },
        array: [1, 2],
        yo: "yo",
      },
      yo: "yo",
    )

    expect(b).to eq(
      foo: {
        bar: {
          qux: "two",
        },
        array: [3, 4],
      },
      dog: "dog",
    )
  end
end
