require "hash_with_quick_access"
require "pp"

describe HashWithQuickAccess do
  it "gives you quick access to hashes or arrays nested in other hashes" do
    hash = HashWithQuickAccess.new(
      name: "Mikkel Hansen",
      books: [
        { name: "Fight Club" },
      ],
      job: {
        title: "Programmer",
      },
    )

    expect(hash.name).to eq "Mikkel Hansen"
    expect(hash.books.first.name).to eq "Fight Club"
    expect(hash.job.title).to eq "Programmer"
  end

  it "only wraps values if they are hashes" do
    hash = HashWithQuickAccess.new(
      books: [
        "Fight Club",
      ],
    )

    expect(hash.books.first).to eq "Fight Club"
  end

  it "gives a useful error when asking for key that doesn't exist" do
    hash = HashWithQuickAccess.new({})

    expect do
      hash.foo.bar.baz
    end.to raise_error(KeyError, "key :foo was not found")
  end

  it "lets you get at the keys" do
    hash = HashWithQuickAccess.new(
      name: "Mikkel Hansen",
      books: [],
    )

    expect(hash.keys).to eq [:name, :books]
  end

  it "allows lookups when the keys are strings" do
    hash = HashWithQuickAccess.new("name" => 1)

    expect(hash.name).to eq 1
  end

  it "lets you use the standard hash #[] method" do
    hash = HashWithQuickAccess.new(job: { title: "Programmer" })

    expect(hash[:job][:title]).to eq "Programmer"
  end

  it "delegate methods to the hash" do
    hash = HashWithQuickAccess.new(a: 1, b: 2)

    expect(hash.map(&:last)).to eq [1, 2]
  end

  it "doesn't delegate if a key exists with the name" do
    hash = HashWithQuickAccess.new(values: 1)

    expect(hash.values).to eq 1
  end

  it "wraps delegated methods in HashWithQuickAccess if they're hashes" do
    hash = HashWithQuickAccess.new(a: 1, b: 2)

    derived_hash = hash.reduce(new: 1337) { |acc, (_, _)| acc }

    expect(derived_hash.new).to eq 1337
  end

  it "adds accessed keys as instance methods" do
    hash = HashWithQuickAccess.new(a: 1)

    hash.a

    expect(hash.methods - Object.new.methods).to include :a
  end

  it "doesn't memoize Hash methods" do
    pp (Hash.new.methods - Object.new.methods).sort
    raise

    hash = HashWithQuickAccess.new(a: 1)

    expect(hash.key?(:a)).to eq true
    expect(hash.key?(:a)).to eq true
  end

  it "can monkey patch Hash with a convenience method" do
    HashWithQuickAccess.add_convenience_method_to_hash!

    hash = { a: 1 }.with_quick_access

    expect(hash.a).to eq 1
  end
end
