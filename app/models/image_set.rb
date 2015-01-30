# == Schema Information
#
# Table name: image_sets
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ImageSet < ActiveRecord::Base

  has_many :configurations

  has_many :image_groups

end
