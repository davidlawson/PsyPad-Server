# == Schema Information
#
# Table name: image_sets
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  name                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  background_image_path :string
#  background_image_size :integer
#

class ImageSet < ActiveRecord::Base

  has_many :configurations
  has_many :image_groups, dependent: :destroy

  accepts_nested_attributes_for :image_groups, allow_destroy: true

  belongs_to :user
  validates_presence_of :user

end
