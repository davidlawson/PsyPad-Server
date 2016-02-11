class AddMoreWavsToImageSets < ActiveRecord::Migration
  def change
    add_column :image_sets, :on_wav_path, :string
    add_column :image_sets, :on_wav_size, :integer
    add_column :image_sets, :off_wav_path, :string
    add_column :image_sets, :off_wav_size, :integer
    add_column :image_sets, :timeout_wav_path, :string
    add_column :image_sets, :timeout_wav_size, :integer
  end
end
