module Applicationable
  extend ActiveSupport::Concern

  included do
    has_one :application
  end

  def target_type_name
    raise NotImplementedError
  end
end
