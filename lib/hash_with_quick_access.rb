class HashWithQuickAccess
  def self.add_convenience_method_to_hash!
    Hash.send(:include, ConvenienceMethod)
  end

  def initialize(hash)
    @hash = hash
  end

  def method_missing(key, *args, &block)
    value = if key?(key)
              fetch_possibly_decorated_value(key)
            elsif hash.respond_to?(key)
              delegate_and_decorate(key, *args, &block)
            else
              fail KeyError, "key :#{key} was not found"
            end

    if !hash.respond_to?(key)
      define_singleton_method(key) { value }
    end

    value
  end

  def respond_to?(method_name, include_private = false)
    key?(method_name) || super
  end

  def keys
    hash.keys.map(&:to_sym)
  end

  def [](key)
    send(key)
  end

  private

  attr_reader :hash

  def delegate_and_decorate(method_name, *args, &block)
    obj = hash.send(method_name, *args, &block)
    possibly_decorate(obj)
  end

  def fetch_possibly_decorated_value(key)
    obj = hash.fetch(key) { hash.fetch(key.to_s) }
    possibly_decorate(obj)
  end

  def possibly_decorate(obj)
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
    hash.keys.flat_map do |key|
      [key, key.to_sym]
    end
  end

  module ConvenienceMethod
    def with_quick_access
      HashWithQuickAccess.new(self)
    end
  end
end
