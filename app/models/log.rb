# == Schema Information
#
# Table name: logs
#
#  id             :integer          not null, primary key
#  participant_id :integer
#  test_date      :datetime         not null
#  content        :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Log < ActiveRecord::Base

  belongs_to :user
  belongs_to :participant

  validates_presence_of :test_date
  validates_presence_of :content

end
