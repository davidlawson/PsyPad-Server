# == Schema Information
#
# Table name: image_sets
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  name                  :string
#  directory             :string
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
  validates_presence_of :name
  validates_presence_of :directory

  before_validation do |record|
    if new_record?
      unless record.directory.present?
        dir = Rails.application.config.image_set_directory + SecureRandom.urlsafe_base64
        FileUtils.mkdir_p dir
        record.directory = dir
      end
    end
  end

  before_destroy do |record|
    FileUtils.rm_rf record.directory
  end

  # this is shown in <select>s
  def display_name
    s = name
    if user == User.first
      s = '[Shared] ' + s
    end
    s
  end

end
