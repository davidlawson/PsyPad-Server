class CreateImageSets < ActiveRecord::Migration
  def change
    create_table :image_sets do |t|

      t.belongs_to :user, index: true, null: :false
      t.string :name, null: :false

      t.string :directory, null: false

      t.timestamps null: false
    end
  end
end
