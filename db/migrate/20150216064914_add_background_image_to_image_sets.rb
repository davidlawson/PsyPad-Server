class AddBackgroundImageToImageSets < ActiveRecord::Migration
  def change
    add_column :image_sets, :background_image_path, :string
    add_column :image_sets, :background_image_size, :integer
  end
end
