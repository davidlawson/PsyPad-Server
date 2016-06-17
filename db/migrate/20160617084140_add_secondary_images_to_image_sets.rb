class AddSecondaryImagesToImageSets < ActiveRecord::Migration
  def change
  	add_column :image_sets, :secondary_image1_path, :string
    add_column :image_sets, :secondary_image1_size, :integer
    add_column :image_sets, :secondary_image2_path, :string
    add_column :image_sets, :secondary_image2_size, :integer
    add_column :image_sets, :secondary_image3_path, :string
    add_column :image_sets, :secondary_image3_size, :integer
    add_column :image_sets, :secondary_image4_path, :string
    add_column :image_sets, :secondary_image4_size, :integer
  end
end
