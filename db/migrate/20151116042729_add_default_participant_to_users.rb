class AddDefaultParticipantToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :default_participant, index: true
  end
end
