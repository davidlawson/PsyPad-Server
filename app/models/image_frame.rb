# == Schema Information
#
# Table name: image_frames
#
#  id                 :integer          not null, primary key
#  image_id           :integer
#  frame_file_name    :string
#  frame_content_type :string
#  frame_file_size    :integer
#  frame_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ImageFrame < ActiveRecord::Base

  belongs_to :image

  has_attached_file :frame
  validates_attachment :frame, :presence => true,
                       :content_type => { :content_type => 'image/png' }

  def image_group
    image.image_group
  end

  def image_set
    image_group.image_set
  end

end
