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
  JITA_REGION_ID = "10000002" # JITA

  def self.jita_stations
    all.where(region_id: JITA_REGION_ID)
  end
end
