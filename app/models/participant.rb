# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  username   :string           not null
#  enabled    :boolean          default("true")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Participant < ActiveRecord::Base

  belongs_to :user
  has_many :logs

end
