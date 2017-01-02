# == Schema Information
#
# Table name: corporation_relations
#
#  id         :integer          not null, primary key
#  ancestor   :integer          not null
#  descendant :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class CorporationRelation < ActiveRecord::Base
  belongs_to :ancestor_corporation, class_name: 'Corporation', foreign_key: :ancestor
  belongs_to :descendant_corporation, class_name: 'Corporation', foreign_key: :descendant

  def self.relation_corporation(corporation_id)
    p = CorporationRelation.where(descendant: corporation_id)
    if p.present?
      relations = CorporationRelation.where(ancestor: p.map(&:ancestor))
      relations.map(&:descendant)
    else
      [corporation_id]
    end
  end
end
