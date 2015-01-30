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

class ImageGroup < ActiveRecord::Base

  belongs_to :image_set
  has_many :images

end
