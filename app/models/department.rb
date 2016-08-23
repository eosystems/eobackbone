# == Schema Information
#
# Table name: departments
#
#  id              :integer          not null, primary key
#  department_name :string(255)      not null
#  delete_flag     :boolean          default(FALSE), not null
#  corporation_id  :integer
#  buy_percentage  :integer          default(90), not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Department < ActiveRecord::Base
  has_many :orders
  belongs_to :corporation

  # 指定したCorpに属している
  scope :accessible_departments, -> (corporation_id) do
    cid = arel_table[:corporation_id]
    where(cid.eq(corporation_id))
  end

end
