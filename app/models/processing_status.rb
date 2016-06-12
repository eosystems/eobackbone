class ProcessingStatus < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path 'config/divisions'
  set_filename "processing_status"

  enum_accessor :id
end
