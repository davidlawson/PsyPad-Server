class CreateImageSets < ActiveRecord::Migration
  def change
    create_table :image_sets do |t|

      t.belongs_to :user, index: true
      t.string :name

      t.timestamps null: false
    end
  end
end
