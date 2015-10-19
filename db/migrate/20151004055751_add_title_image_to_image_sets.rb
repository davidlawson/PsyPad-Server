class AddTitleImageToImageSets < ActiveRecord::Migration
  def change
    add_column :image_sets, :title_image_path, :string
    add_column :image_sets, :title_image_size, :integer
  end
end
