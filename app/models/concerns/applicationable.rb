module Applicationable
  extend ActiveSupport::Concern

  included do
    has_one :application, as: :targetable
  end

  def target_type_name
    raise NotImplementedError
  end

  def has_update_operation_role
    raise NotImplementedError
  end
end
