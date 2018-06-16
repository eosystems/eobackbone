# == Schema Information
#
# Table name: corporation_relations
#
#  id          :integer          not null, primary key
#  ancestor    :integer          not null
#  descendant  :integer          not null
#  only_parent :boolean          default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class CorporationRelation < ActiveRecord::Base
  belongs_to :ancestor_corporation, class_name: 'Corporation', foreign_key: :ancestor
  belongs_to :descendant_corporation, class_name: 'Corporation', foreign_key: :descendant

  # 親だけ見られる設定をしている場合、only_parentにtrueを設定する
  def self.relation_corporation(corporation_id, operation_auth: false)
    p = CorporationRelation.where(descendant: corporation_id)
    if p.present?
      if p.first.only_parent
        return [corporation_id]
      end

      # 権限がなければ親だけ見られるコープ情報は見られない
      if operation_auth
        relations = CorporationRelation.where(ancestor: p.map(&:ancestor))
      else
        relations =CorporationRelation
          .where(ancestor: p.map(&:ancestor))
          .where(only_parent: false)
      end
      relations.map(&:descendant)
    else
      [corporation_id]
    end
  end
end
