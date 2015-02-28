# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  image_group_id :integer
#  name           :string           not null
#  animated       :boolean          default("false")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Image < ActiveRecord::Base

  belongs_to :image_group, required: true
  has_many :image_frames, dependent: :destroy

  def image_set
    image_group.image_set
  end

end
