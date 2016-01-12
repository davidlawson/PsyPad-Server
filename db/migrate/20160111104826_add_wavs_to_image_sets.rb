class AddWavsToImageSets < ActiveRecord::Migration
  def change
    add_column :image_sets, :incorrect_wav_path, :string
    add_column :image_sets, :incorrect_wav_size, :integer
    add_column :image_sets, :correct_wav_path, :string
    add_column :image_sets, :correct_wav_size, :integer
  end
end
