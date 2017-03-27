class ModStatus < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path 'config/divisions'
  set_filename "mod_status"

  enum_accessor :type
end
