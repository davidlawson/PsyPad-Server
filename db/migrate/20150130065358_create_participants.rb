class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|

      t.belongs_to :user, index: true
      t.string :username, null: false
      t.boolean :enabled, default: true

      t.timestamps null: false
    end
  end
end
