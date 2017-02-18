# == Schema Information
#
# Table name: corp_wallet_divisions
#
#  id             :integer          not null, primary key
#  account_key    :integer          not null
#  name           :string(255)      not null
#  corporation_id :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class CorpWalletDivision < ActiveRecord::Base
  belongs_to :corporation
end
