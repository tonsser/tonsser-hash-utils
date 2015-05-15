require "hash_with_quick_access"

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
end
