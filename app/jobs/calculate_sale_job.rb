class CalculateSaleJob < ActiveJob::Base
  queue_as :default

  BROKER_FEE = 0.0246.freeze

  def perform(date_from, date_to )
    Rails.logger.info("start calculate sale job")

    date_from = DateTime.parse(date_from)
    date_to = DateTime.parse(date_to)

    Trade
        .where(Trade.arel_table[:trade_date].gteq date_from)
        .where(Trade.arel_table[:trade_date].lteq date_to)
        .delete_all

    users = User.all
    users.each do |user|
      items = WalletTransaction
        .where(WalletTransaction.arel_table[:transaction_date].gteq date_from)
        .where(WalletTransaction.arel_table[:transaction_date].lteq date_to)
        .where(user_id: user.id)
        .pluck(:type_id)
        .uniq

      items.each do |item|
        sum_sells = WalletTransaction
          .select('type_id, sum(quantity) as quantity, sum(price * quantity) as t_price, avg(price) as t_average')
          .where(WalletTransaction.arel_table[:transaction_date].gteq date_from)
          .where(WalletTransaction.arel_table[:transaction_date].lteq date_to)
          .where(user_id: user.id)
          .where(transaction_type: 'sell')
          .where(type_id: item)

        sum_buys = WalletTransaction
          .select('type_id, sum(quantity) as quantity, sum(price * quantity) as t_price, avg(price) as t_average')
          .where(WalletTransaction.arel_table[:transaction_date].gteq date_from)
          .where(WalletTransaction.arel_table[:transaction_date].lteq date_to)
          .where(user_id: user.id)
          .where(transaction_type: 'buy')
          .where(type_id: item)

        trade = Trade.new
        trade.trade_date = date_to
        trade.type_id = item
        trade.user_id = user
        tax = 0.0
        trade.sales = 0
        if sum_sells.present? && sum_sells[0].quantity != nil
          trade.sales_quantity = sum_sells[0].quantity
          trade.sales_average_price = sum_sells[0].t_average
          trade.sales = sum_sells[0].t_price
          tax = tax + trade.sales * BROKER_FEE
        end
        if sum_buys.present? && sum_buys[0].quantity != nil
          trade.purchase_quantity = sum_buys[0].quantity
          trade.purchase_average_price = sum_buys[0].t_average
          trade.cost = sum_buys[0].t_price
          tax = tax + trade.cost * BROKER_FEE
        end
        trade.tax = tax
        trade.expense = tax + trade.cost
        trade.profit = trade.sales - trade.expense
        trade.save!
      end
    end

    Rails.logger.info("end calculate sale job")
  end
end
