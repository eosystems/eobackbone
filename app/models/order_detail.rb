# == Schema Information
#
# Table name: order_details
#
#  id                  :integer          not null, primary key
#  order_id            :integer          not null
#  item_id             :integer          not null
#  unit_price          :decimal(20, 4)   default(0.0), not null
#  sell_unit_price     :decimal(20, 4)   default(0.0), not null
#  buy_unit_price      :decimal(20, 4)   default(0.0), not null
#  quantity            :integer          not null
#  volume              :decimal(20, 4)   default(0.0), not null
#  pre_sell_unit_price :decimal(20, 4)   default(0.0), not null
#  pre_buy_unit_price  :decimal(20, 4)   default(0.0), not null
#  pre_quantity        :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class OrderDetail < ActiveRecord::Base
  IMAGE_SERVER_PATH = "https://image.eveonline.com/Type/%d_32.png".freeze
  # 買取価格係数 元の価格に一定係数かけたものを買取額とする
  PURCHASE_FACTOR = 0.8

  attr_accessor :raw_item_name

  # Relations
  belongs_to :order
  belongs_to :item, foreign_key: :item_id, class_name: 'InvType'

  # Delegates
  delegate :type_name, to: :item, prefix: :item

  # Methods

  def price
    BigDecimal.new(unit_price) * BigDecimal.new(quantity || 0)
  end

  def sell_price
    BigDecimal.new(unit_price) * BigDecimal.new(quantity || 0)
  end

  def image_path
    IMAGE_SERVER_PATH % [self.item_id || 0]
  end

  def retrieval!
    item = nil

    begin
      item = InvType.find_by("type_name = ?", "#{self.raw_item_name.gsub("*", "")}")
      self.item_id = item.type_id
    rescue => e
      begin
        self.item_id = TrnTranslation.find_by("text = ? and tc_id = 8", "#{self.raw_item_name.gsub("*", "")}").key_id
      rescue => e
        raise self.raw_item_name.gsub("*","").to_s + " は解析に失敗しました"
      end
    end
    self.unit_price = MarketOrder.jita_buy_price(self.item_id)
    # WH特別対応
    # Ancient Coordinates Database
    # Neural Network Analyzer
    # Sleeper Data Library
    # Sleeper Drone AI Nexus
    # 上記のアイテムはNPC買取価格を設定
    if self.item_id == 30746 || self.item_id == 30744 || self.item_id == 30745 || self.item_id == 30747
      self.unit_price = item.base_price
    end

    self.sell_unit_price = self.unit_price
  end
end
