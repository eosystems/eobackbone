# == Schema Information
#
# Table name: order_details
#
#  id              :integer          not null, primary key
#  order_id        :integer          not null
#  item_id         :integer          not null
#  unit_price      :decimal(20, 4)   default(0.0), not null
#  sell_unit_price :decimal(20, 4)   default(0.0), not null
#  quantity        :integer          not null
#  volume          :decimal(20, 4)   default(0.0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class OrderDetail < ActiveRecord::Base
  IMAGE_SERVER_PATH = "https://image.eveonline.com/Type/%d_64.png".freeze
  # 買取価格係数 元の価格に一定係数かけたものを買取額とする
  PURCHASE_FACTOR = 0.9

  attr_accessor :raw_item_name

  # Relations
  belongs_to :order
  belongs_to :item, foreign_key: :item_id, class_name: 'InvType'

  # Methods

  def price
    BigDecimal.new(unit_price) * BigDecimal.new(quantity || 0)
  end

  def sell_price
    BigDecimal.new(unit_price) * BigDecimal.new(quantity || 0) * PURCHASE_FACTOR
  end


  def image_path
    IMAGE_SERVER_PATH % [self.item_id || 0]
  end

  def retrieval!
    self.item_id = InvType.find_by("type_name like ?", "%#{self.raw_item_name.gsub("*", "")}%").type_id
    self.unit_price = MarketOrder.jita_buy_price(self.item_id)
    self.sell_unit_price = self.unit_price * PURCHASE_FACTOR
  end
end
