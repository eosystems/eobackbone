class OperationRole < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path 'config/divisions'
  set_filename 'operation_role'

  enum_accessor :type
end
