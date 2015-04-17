# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  username   :string           not null
#  enabled    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Participant < ActiveRecord::Base

  belongs_to :user, required: true
  has_many :logs, dependent: :destroy
  has_many :participant_configurations, dependent: :destroy

  validates :username, format: { with: /\A[a-z0-9]+\Z/, message: 'Username must only contain lowercase a-z and 0-9.' }

  validate :unique_username

  def unique_username
    if user.participants.where(username: username).where.not(id: id).count > 0
      errors.add(:username, 'must be unique')
    end
  end

  before_save :default_values
  def default_values
    self.user_id ||= current_user
  end

  def to_s
    username
  end

end
