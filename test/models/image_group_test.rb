# == Schema Information
#
# Table name: image_groups
#
#  id           :integer          not null, primary key
#  image_set_id :integer
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ImageGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
