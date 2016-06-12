class AddSecondaryStimuliToConfiguration < ActiveRecord::Migration
  def change
    add_column :configurations, :enable_secondary_stimuli, :boolean, default: false
  end
end
