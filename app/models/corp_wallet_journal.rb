# == Schema Information
#
# Table name: corp_wallet_journals
#
#  id                      :integer          not null, primary key
#  i_date                  :datetime         not null
#  ref_id                  :integer          not null
#  ref_type_id             :integer
#  owner_name1             :string(255)
#  owner_id1               :integer
#  owner_name2             :string(255)
#  owner_id2               :integer
#  arg_name1               :string(255)
#  arg_id_1                :integer
#  amount                  :decimal(20, 4)   default(0.0), not null
#  balance                 :decimal(20, 4)   default(0.0), not null
#  reason                  :string(255)
#  owner1_type_id          :integer
#  owner2_type_id          :integer
#  corporation_id          :string(255)      not null
#  corp_wallet_division_id :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class CorpWalletJournal < ActiveRecord::Base
  include NgTableSearchable

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    corp_wallet_division_id: :corp_wallet_division_id_eq,
    corporation_id: :corporation_id_eq,
    journal_corporation_name: :corporation_corporation_name_cont_any,
    from_i_date: :i_date_gteq,
    to_i_date: :i_date_lteq,
    ref_type_id: :ref_type_id_eq,
    ref_type_name: :ref_type_name_cont_any
  }.with_indifferent_access.freeze

  # Relations
  belongs_to :corporation
  belongs_to :ref_type

  # Delegates
  delegate :corporation_name, to: :corporation, allow_nil: true, prefix: :journal
  delegate :name, to: :ref_type, allow_nil: true, prefix: :ref_type

  # Scopes
  # 指定したCorpに属していれば参照可能
  scope :accessible_orders, -> (corporation_id) do
    cid = arel_table[:corporation_id]

    relation_corporations = CorporationRelation.relation_corporation(corporation_id)
    where(cid.in(relation_corporations))
  end

  # Methods
  def import_all_corporation_journals
    corps = CorpApiManagement.all
    corps.each do |corp|
      import_all_division_journals(corp.key_id, corp.v_code, corp.corporation_id)
    end
  end

  def import_all_division_journals(key_id, v_code, corporation_id)
    divisions = CorpWalletDivision.where(corporation_id: corporation_id)
    divisions.each do |division|
      import_journals(key_id, v_code, corporation_id,division.id, account_key: division.account_key)
    end
  end

  def import_journals(key_id, v_code, corporation_id, division_id, account_key: 1000, last_from_id: 0)
    client = EveClient.new(key_id, v_code)
    response = client.fetch_corp_wallet_journals(account_key: account_key, from_id: last_from_id)
    if response.items.count != 0 && response.items[0].rowset.row != nil
      save_journals(response, division_id, corporation_id)
    end
  end

  def save_journals(response, division_id, corporation_id)
    items = response.items[0].rowset.row.map{ |v| HashObject.new(v) }
    results = []
    i = 0
    items.each do |item|
      exist_check = CorpWalletJournal.where(ref_id: item.refID)
      if exist_check.count == 0
        r = CorpWalletJournal.new
        r.i_date = item.date
        r.ref_id = item.refID
        r.ref_type_id = item.refTypeID
        r.owner_name1 = item.ownerName1
        r.owner_id1 = item.ownerID1
        r.owner_name2 = item.ownerName2
        r.owner_id2 = item.ownerID2
        r.arg_name1 = item.argName1
        r.arg_id_1 = item.argID1
        r.amount = item.amount
        r.balance = item.balance
        r.reason = item.reason
        r.owner1_type_id = item.owner1TypeID
        r.owner2_type_id = item.owner2TypeID
        r.corp_wallet_division_id = division_id
        r.corporation_id = corporation_id
        results << r
      end
      if (i % 1000 == 0)
        CorpWalletJournal.import results
        results = []
      end
      i = i + 1
    end

    CorpWalletJournal.import results
  end

  def self.summary(from_i_date, to_i_date, corporation_id, division_id)
    CorpWalletJournal.group(:ref_type)
      .where(corporation_id: corporation_id, corp_wallet_division_id: division_id)
      .sum(:amount)
  end
end
