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
#  transaction_type       :string(255)
#  transaction_for        :string(255)
#  journal_transaction_id :integer
#  client_type_id         :integer
#  trade                  :boolean          default(FALSE), not null
#  user_id                :integer          not null
#  created_at             :datetime
#  updated_at             :datetime
#

class ApiKeyInfo < ActiveRecord::Base

  belongs_to :user, class_name: 'User', foreign_key: :user_id
end
