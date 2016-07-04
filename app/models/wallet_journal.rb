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

class WalletJournal < ActiveRecord::Base
  EVE_CHAR_API_PATH = "https://api.eveonline.com/char/WalletJournal.xml.aspx?"

  belongs_to :user, class_name: 'User', foreign_key: :user_id

  def self.url(key_id, v_code, character_id)
    EVE_CHAR_API_PATH + "keyID=" + key_id + "&vCode=" + v_code + "&characterID=" + character_id + "&rowCount=" + "1000"
  end

  def self.update(user_id)
    user = User.find(user_id)

    wallet_transactions = XmlApiBase.fetch(self.url(user.user_detail.key_id, user.user_detail.verification_code, user.uid))
    results = Hash.from_xml(wallet_transactions.body)["eveapi"]["result"]["rowset"]["row"]
    results.each do |r|
      u = WalletJournal.find_or_initialize_by(ref_id: r["refID"])
      u.attributes = {
        user_id: user_id,
        transaction_date: Time.zone.parse(r["date"]) + 9.hour,
        ref_type_id: r["refTypeID"],
        owner_name_1: r["ownerName1"],
        owner_id_1: r["ownerID1"],
        owner_name_2: r["ownerName2"],
        owner_id_2: r["ownerID2"],
        arg_name_1: r["argName1"],
        arg_id: r["argID1"],
        amount: r["amount"],
        balance: r["balance"],
        reason: r["reason"],
        tax_receiver_id: r["taxReceiverID"],
        tax_amount: r["taxAmount"]
      }
      u.save!
    end
  end

end
