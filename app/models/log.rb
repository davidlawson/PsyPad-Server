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

  def parsed_content
    content.scan(/([^|]+)\|([^|]+)\|([^\n]+)/)
  end

  def parsed_configuration
    JSON.parse(parsed_content[0][2]) rescue nil
  end

  def configuration_name
    parsed_configuration['name'] rescue nil
  end

end
