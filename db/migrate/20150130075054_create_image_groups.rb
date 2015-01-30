class CreateImageGroups < ActiveRecord::Migration
  def change
    create_table :image_groups do |t|

      t.belongs_to :image_set, index: true

      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
