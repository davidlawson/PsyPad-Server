# == Schema Information
#
# Table name: image_frames
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  frame_name :string
#  frame_path :string
#  frame_size :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ImageFrame < ActiveRecord::Base

  belongs_to :image, required: true

  validates_presence_of :frame_path

  before_save do |record|
    record.frame_name = File.basename(record.frame_path)
  end

  before_destroy do |record|
    FileUtils.rm_rf record.frame_path
  end

  def thumbnail_data_uri(max_width=100)
    image = MiniMagick::Image.open(frame_path)
    image.resize max_width.to_s + '>'
    base64 = Base64.encode64(image.to_blob).gsub(/\s+/, "")
    "data:image/png;base64,#{Rack::Utils.escape(base64)}"
  end

  def data_uri
    base64 = Base64.encode64(File.read(frame_path)).gsub(/\s+/, "")
    "data:image/png;base64,#{Rack::Utils.escape(base64)}"
  end

  def image_group
    image.image_group
  end

  def image_set
    image_group.image_set
  end

end
