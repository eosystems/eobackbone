class OrderStatus < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path 'config/divisions'
  set_filename "order_status"

  enum_accessor :type
end
