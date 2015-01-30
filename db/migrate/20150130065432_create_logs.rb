class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|

      t.belongs_to :participant, index: true

      t.datetime :test_date
      t.text :content

      t.timestamps null: false
    end
  end
end
