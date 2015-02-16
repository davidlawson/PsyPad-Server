class CreateImageFrames < ActiveRecord::Migration
  def change
    create_table :image_frames do |t|

      t.belongs_to :image

      t.string :frame_name
      t.string :frame_path
      t.integer :frame_size

      t.timestamps null: false
    end
  end
end
