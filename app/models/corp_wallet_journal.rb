# == Schema Information
#
# Table name: corp_wallet_journals
#
#  id             :integer          not null, primary key
#  i_date         :datetime         not null
#  ref_id         :integer          not null
#  ref_type_id    :integer          not null
#  owner_name1    :string(255)      not null
#  owner_id1      :integer          not null
#  owner_name2    :string(255)      not null
#  owner_id2      :integer          not null
#  arg_name1      :string(255)      not null
#  arg_id_1       :integer          not null
#  amount         :decimal(20, 4)   default(0.0), not null
#  balance        :decimal(20, 4)   default(0.0), not null
#  reason         :string(255)      not null
#  owner1_type_id :integer          not null
#  owner2_type_id :integer          not null
#  corporation_id :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class CorpWalletJournal < ActiveRecord::Base
  belongs_to :corporation

end
