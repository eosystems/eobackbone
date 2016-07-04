# == Schema Information
#
# Table name: wallet_transactions
#
#  id                     :integer          not null, primary key
#  transaction_date       :datetime
#  transaction_id         :integer          not null
#  quantity               :integer
#  type_name              :string(255)
#  type_id                :integer
#  price                  :decimal(20, 4)
#  client_id              :integer
#  client_name            :string(255)
#  station_id             :integer
#  station_name           :string(255)
#  transation_type        :string(255)
#  transaction_type       :string(255)
#  transaction_for        :string(255)
#  journal_transaction_id :integer
#  client_type_id         :integer
#  user_id                :integer          not null
#  created_at             :datetime
#  updated_at             :datetime
#

class WalletTransactions < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :item, foreign_key: :type_id, class_name: 'InvType'
  belongs_to :station, foreign_key: :station_id, class_name: "StaStation"
  belongs_to :wallet_journal
end
