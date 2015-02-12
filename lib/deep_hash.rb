# This class is useful for checking for keys within nested hashes
#
# Turns
#
#   params[:foo] && params[:foo][:bar] && params[:foo][:bar][:baz]
#
# into
#
#   DeepHash.new(params).dig(:foo, :bar, :baz)
class DeepHash
  def initialize(hash)
    @hash = hash
  end

  def dig(*keys)
    keys.inject(@hash) do |location, key|
      if location.nil?
        nil
      else
        location[key]
      end
    end
  end
end
