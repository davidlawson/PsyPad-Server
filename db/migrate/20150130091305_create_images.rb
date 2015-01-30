class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|

      t.belongs_to :image_group, index: true

      t.string :name, null: false
      t.boolean :animated, default: false

      t.timestamps null: false
    end
  end
end
