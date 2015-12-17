class Site
  FIELDS = %w{ organizations }
  def initialize(data = {})
    @attributes = data
  end

  def read_attribute(name)
    @attributes[name.to_s]
  end

  def updated_at
    date = read_attribute(:updated_at)
    return if date.nil?
    DateTime.parse(date)
  end

  def has_field?(name)
    FIELDS.include?(name.to_s) || @attributes.has_key?(name.to_s)
  end

  def cache_key
    [siteid, updated_at.to_i].join('-')
  end

  def method_missing(field)
    if has_field?(field)
      read_attribute(field)
    else
      super
    end
  end
end
