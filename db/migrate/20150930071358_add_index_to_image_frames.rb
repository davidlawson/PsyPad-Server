class AddIndexToImageFrames < ActiveRecord::Migration
  def change
    add_index :image_frames, :image_id
  end
end
