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

  def import_all_corporation_journals
    corps = CorpApiManagement.all
    corps.each do |corp|
      import_journals(corp.key_id, corp.v_code, corp.corporation_id)
    end
  end

  def import_journals(key_id, v_code, corporation_id)
    client = EveClient.new(key_id, v_code)
    response = client.fetch_corp_wallet_journals
    items = response.items[0].rowset.row.map{ |v| HashObject.new(v) }

    results = []
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
        r.corporation_id = corporation_id
        results << r
      end
    end

    CorpWalletJournal.import results
  end
end
