# == Schema Information
#
# Table name: wallet_journals
#
#  id               :integer          not null, primary key
#  transaction_date :datetime
#  ref_id           :integer
#  ref_type_id      :integer
#  owner_name_1     :string(255)
#  owner_id_1       :integer
#  owner_name_2     :string(255)
#  owner_id_2       :integer
#  arg_name_1       :string(255)
#  arg_id           :integer
#  amount           :decimal(20, 4)
#  balance          :decimal(20, 4)
#  reason           :string(255)      not null
#  tax_receiver_id  :integer
#  tax_amount       :decimal(20, 4)
#  user_id          :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#

class WalletJournals < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
end
