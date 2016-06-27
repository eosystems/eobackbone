class InventoryParseService
  def parse(text)
    order = Order.new
    order.order_details = text
      .split("\n")
      .map { |v| v.split("\t") }
      .map { |name, quantity, _, _, _, volume|
      if quantity == ""
        quantity = 1.to_s # リパッケージしていない場合
      end
      OrderDetail.new(raw_item_name: name, quantity: quantity.delete(','), volume: volume.delete(','))
      }.select { |detail| detail.quantity.present? }
    order
  rescue => e
    Rails.logger.error "[ERROR] Inventory Parse Error"
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    nil
  end
end
