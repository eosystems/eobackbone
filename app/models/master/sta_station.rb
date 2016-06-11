# == Schema Information
#
# Table name: sta_stations
#
#  id              :integer          not null, primary key
#  station_id      :integer          not null
#  region_id       :integer          not null
#  solar_system_id :integer          not null
#  station_name    :string(255)      not null
#

class StaStation < ActiveRecord::Base

end
