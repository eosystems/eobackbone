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
#  mod_status              :integer
#  ignore                  :boolean          default(FALSE), not null
#  mod_ref_type_id         :integer
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
    ref_type_name: :ref_type_name_cont_any,
    ignore: :ignore_eq_any
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
  def admin_token
    User.find_by(uid: 91247469).token # 管理者
  end

  def admin_corp
    98440844
  end

  def import_all_corporation_journals(target: admin_corp)
    token = admin_token

    client = EsiClient.new(token)

    targets = []
    if target.present?
      targets = target.split(',')
    else
      targets = [*1..7]
    end

    targets.each do |i|
      retry_count = 0
      page = 1
      loop do
        res = client.fetch_corp_wallet_journal(admin_corp, i, page)
        if res.items.size == 0 || !res.is_success
          Rails.logger.info("fetch failed. Retry(retry count: #{retry_count})")
          if retry_count >= 3
            fail 'Retry Limit.'
          else
            retry_count += 1
            redo
          end
        else
          retry_count = 0
          save_journals(res.items, i, admin_corp)
          if res.has_next_page
            page += 1
          else
            break
          end
        end
      end
    end
  end

  def save_journals(items, division_id, corporation_id)
    results = []
    i = 0

    items.each do |item|
      exist_check = CorpWalletJournal.where(ref_id: item.id)
      if exist_check.count == 0
        r = CorpWalletJournal.new
        r.amount = item.amount
        r.balance = item.balance
        r.reason = item.reason
        r.ref_id = item.id
        r.i_date = item.date
        r.reason = item.description

        ref_type = item.ref_type
        ref_type_eo = RefType.find_by(name: ref_type)
        if ref_type_eo.blank?
          last_id = RefType.last.id
          ref_type_eo = RefType.new(id: last_id + 1,name: ref_type)
          ref_type_eo.save
          ref_type_eo.reload
        end
        r.ref_type_id = ref_type_eo.id
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
    results = []
    r = CorpWalletJournal.group(:ref_type_id)
      .where(corporation_id: corporation_id, corp_wallet_division_id: division_id)
      .where(i_date: from_i_date..to_i_date)
      .where(ignore: false)
      .sum(:amount)
      .select
    r.each { |id, v|
      results << CorpWalletJournal.new(id: id, ref_type_id: id, amount: v)
    }
    results.sort {|a, b| a.ref_type_name <=> b.ref_type_name}
  end

  def self.to_csv(journals)
    CSV.generate do |csv|
      csv << column_names
      journals.each do |journal|
        csv << journal.attributes.values_at(*column_names)
      end
    end
  end
end
