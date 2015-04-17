class AddDescriptionToConfigurations < ActiveRecord::Migration
  def change
    add_column :configurations, :description, :string
  end
end
