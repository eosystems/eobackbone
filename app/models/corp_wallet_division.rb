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

  # Scopes
  # 指定したCorpに属していれば参照可能
  scope :accessible_divisions, -> (corporation_id) do
    cid = arel_table[:corporation_id]

    relation_corporations = CorporationRelation.relation_corporation(corporation_id)
    where(cid.in(relation_corporations))
  end

  # Delegates
  delegate :corporation_name, to: :corporation, allow_nil: true, prefix: :division

end
