class AddHookUrlToUser < ActiveRecord::Migration
  def change
    add_column :users, :hook_url, :string
  end
end
