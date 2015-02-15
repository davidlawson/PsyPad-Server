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

require 'test_helper'

class ImageFrameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
