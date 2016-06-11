# == Schema Information
#
# Table name: order_details
#
#  id         :integer          not null, primary key
#  order_id   :integer          not null
#  item_id    :integer          not null
#  unit_price :decimal(20, 4)   default(0.0), not null
#  quantity   :integer          not null
#  volume     :decimal(20, 4)   default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrderDetail < ActiveRecord::Base
  attr_accessor :raw_item_name

  # Relations
  belongs_to :order

  # Methods

  def price
    BigDecimal.new(unit_price) * BigDecimal.new(quantity || 0)
  end

  def image_path
    # TODO: fixme
    "https://image.eveonline.com/Type/14264_64.png"
  end

  def retrieval!
    # TODO: item_nameからitem_idを引いてくる
    self.item_id = 34
    # TODO: 商品IDから販売価格を引いてくる
    self.unit_price = 1000.000
  end
end
