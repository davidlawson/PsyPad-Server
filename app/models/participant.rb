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
  has_many :logs, dependent: :destroy
  has_many :configurations, dependent: :destroy

  before_save :default_values
  def default_values
    self.user_id ||= current_user
  end

  def to_s
    username
  end

end
