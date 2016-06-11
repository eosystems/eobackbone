class HashObject
  include ActiveModel::Model

  def initialize(hash)
    hash.each do |k, v|
      instance_variable_set("@#{k}", v.is_a?(Hash) ? HashObject.new(v) : v)
      self.class.send(:define_method, k, proc { instance_variable_get("@#{k}") })
      self.class.send(:define_method, "#{k}=", proc { |v| instance_variable_set("@#{k}", v) })
    end
  end
end
