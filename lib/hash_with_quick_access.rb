class HashWithQuickAccess
  def initialize(hash)
    @hash = hash
  end

  def method_missing(key)
    if key?(key)
      fetch_possibly_decorated_value(key)
    else
      fail KeyError, "key :#{key} was not found"
    end
  end

  def respond_to?(method_name, include_private = false)
    key?(method_name) || super
  end

  def keys
    @hash.keys.map(&:to_sym)
  end

  def [](key)
    send(key)
  end

  private

  def fetch_possibly_decorated_value(key)
    obj = @hash.fetch(key) { @hash.fetch(key.to_s) }

    if should_be_decorated(obj)
      decorate(obj)
    else
      obj
    end
  end

  def should_be_decorated(obj)
    (obj.is_a?(Array) && obj[0].is_a?(Hash)) || obj.is_a?(Hash)
  end

  def decorate(obj)
    if obj.is_a?(Array)
      obj.map { |o| HashWithQuickAccess.new(o) }
    elsif obj.is_a?(Hash)
      HashWithQuickAccess.new(obj)
    end
  end

  def key?(key)
    all_keys.include?(key)
  end

  def all_keys
    @hash.keys.flat_map do |key|
      [key, key.to_sym]
    end
  end
end
