class AddButtonImagesToImageSets < ActiveRecord::Migration
  def change
    add_column :image_sets, :button1_image_path, :string
    add_column :image_sets, :button1_image_size, :integer
    add_column :image_sets, :button2_image_path, :string
    add_column :image_sets, :button2_image_size, :integer
    add_column :image_sets, :button3_image_path, :string
    add_column :image_sets, :button3_image_size, :integer
    add_column :image_sets, :button4_image_path, :string
    add_column :image_sets, :button4_image_size, :integer
    add_column :image_sets, :secondary_button1_image_path, :string
    add_column :image_sets, :secondary_button1_image_size, :integer
    add_column :image_sets, :secondary_button2_image_path, :string
    add_column :image_sets, :secondary_button2_image_size, :integer
    add_column :image_sets, :secondary_button3_image_path, :string
    add_column :image_sets, :secondary_button3_image_size, :integer
    add_column :image_sets, :secondary_button4_image_path, :string
    add_column :image_sets, :secondary_button4_image_size, :integer
  end
end
