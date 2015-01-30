# == Schema Information
#
# Table name: logs
#
#  id             :integer          not null, primary key
#  participant_id :integer
#  test_date      :datetime
#  content        :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Log < ActiveRecord::Base

  belongs_to :participant

end
