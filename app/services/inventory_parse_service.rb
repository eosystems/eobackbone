class InventoryParseService
  def parse(text)
    order = Order.new
    order.order_details = text
      .split("\n")
      .map { |v| v.split("\t") }
      .map { |name, quantity, _, _, _, _| OrderDetail.new(raw_item_name: name, quantity: quantity) }
      .select { |detail| detail.quantity.present? }
    order
  rescue => e
    Rails.logger.error "[ERROR] Inventory Parse Error"
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    nil
  end
end
