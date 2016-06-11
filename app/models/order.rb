# == Schema Information
#
# Table name: orders
#
#  id                :integer          not null, primary key
#  total_price       :decimal(15, 3)   default(0.0), not null
#  processing_status :string(255)      default("waiting"), not null
#  order_by          :integer          not null
#  assigned_user_id  :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Order < ActiveRecord::Base
  # Relations
  has_many :order_details

  def retrieval!
    self.order_details.each(&:retrieval!)
    self.total_price = order_details.map(&:price).sum
  end
end
