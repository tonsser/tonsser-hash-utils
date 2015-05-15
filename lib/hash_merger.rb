# This class will deep merge two hashes to create one new hash
# with all keys and values from both. If there are duplicate keys
# the latter one wins.
# If some common keys point to arrays, those arrays will be merged
# as well. This is different from Hash#deep_merge, and the reason for
# having this class.
#
# Note that this class uses recursion, which might be dangerous
# in Ruby due to lack of tail call elimination. Recursion is
# however the easiest way to do stuff like this.
class HashMerger
  def initialize(start)
    @start = start
  end

  def merge_with(new)
    do_merge(new, @start.dup)
  end

  private

  def do_merge(hash, acc)
    hash.each_with_object(acc) do |(key, value), _acc|
      acc[key] = if value.is_a?(Hash)
                   do_merge(value, acc[key].dup || {})
                 elsif value.is_a?(Array)
                   (acc[key] || []) + value
                 else
                   value
                 end
    end
  end
end
