# == Schema Information
#
# Table name: image_sets
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  name                  :string
#  directory             :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  background_image_path :string
#  background_image_size :integer
#

require 'test_helper'

class ImageSetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
