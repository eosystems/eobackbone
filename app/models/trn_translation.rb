# == Schema Information
#
# Table name: trn_translations
#
#  id          :integer          not null, primary key
#  tc_id       :string(255)
#  key_id      :integer
#  language_id :string(255)
#  text        :text(65535)
#

class TrnTranslation < ActiveRecord::Base
end
