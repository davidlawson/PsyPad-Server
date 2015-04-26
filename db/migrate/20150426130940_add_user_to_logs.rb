class AddUserToLogs < ActiveRecord::Migration
  def change
    add_reference :logs, :user, index: true
    add_foreign_key :logs, :users
  end
end
