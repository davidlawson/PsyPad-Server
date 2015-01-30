# == Schema Information
#
# Table name: image_frames
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ImageFrame < ActiveRecord::Base

  belongs_to :image

  has_attached_file :frame
  validates_attachment :frame, :presence => true,
                       :content_type => { :content_type => 'image/png'}

end
