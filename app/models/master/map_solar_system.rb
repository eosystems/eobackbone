# == Schema Information
#
# Table name: map_solar_systems
#
#  id                :integer          not null, primary key
#  region_id         :integer          not null
#  solar_system_id   :integer          not null
#  solar_system_name :string(255)      not null
#

class MapSolarSystem < ActiveRecord::Base

end
