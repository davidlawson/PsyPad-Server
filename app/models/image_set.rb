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

  accepts_nested_attributes_for :image_groups, allow_destroy: true

  belongs_to :user

end
