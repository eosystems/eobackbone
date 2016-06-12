# == Schema Information
#
# Table name: inv_types
#
#  id              :integer          not null
#  type_id         :integer          not null, primary key
#  group_id        :integer
#  type_name       :string(255)
#  description     :text(65535)
#  mass            :float(53)
#  volume          :float(53)
#  base_price      :decimal(20, 4)
#  market_group_id :integer
#

class InvType < ActiveRecord::Base
  self.primary_key = 'type_id'
end
