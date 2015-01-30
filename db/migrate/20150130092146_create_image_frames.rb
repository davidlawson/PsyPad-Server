class CreateImageFrames < ActiveRecord::Migration
  def change
    create_table :image_frames do |t|

      t.belongs_to :image

      t.attachment :frame

      t.timestamps null: false
    end
  end
end
