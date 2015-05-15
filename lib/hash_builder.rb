# This class simplifies the creation of potentially deeply nested hashes
# It turns code like this:
#
#   hash = {
#     one: {
#       two: {
#         three: {
#           four: :foo
#         }
#       }
#     }
#   }
#
# Into this:
#
#   hash = HashBuilder.new
#   hash.one.two.three.four = :foo
#
# The underlaying hash can be retrieved with `#as_json`.
#
# NOTE: Its good practice to also implement respond_to_missing? when
# overriding method_missing, but for some reason that makes the tests fail.
class HashBuilder
  def initialize
    @hash = {}
  end

  def as_json
    @hash.as_json
  end

  def method_missing(name, *args)
    match = name.to_s.match(/(?<key>.*?)=$/)

    if match.present?
      @hash[match[:key].to_sym] = args.first
    else
      @hash[name] = HashBuilder.new if @hash[name].blank?
      @hash[name]
    end
  end
end
