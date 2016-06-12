class AddSecondaryStimuliButtonConfigurationToConfigurations < ActiveRecord::Migration
  def change

	add_column :configurations, :integer, :num_secondary_buttons, default: 4

	add_column :configurations, :string, :secondary_button1_text
	add_column :configurations, :string, :secondary_button2_text
	add_column :configurations, :string, :secondary_button3_text
	add_column :configurations, :string, :secondary_button4_text

	add_column :configurations, :string, :secondary_button1_bg, default: '#6c6c6c'
	add_column :configurations, :string, :secondary_button2_bg, default: '#6c6c6c'
	add_column :configurations, :string, :secondary_button3_bg, default: '#6c6c6c'
	add_column :configurations, :string, :secondary_button4_bg, default: '#6c6c6c'

	add_column :configurations, :string, :secondary_button1_fg, default: '#ffffff'
	add_column :configurations, :string, :secondary_button2_fg, default: '#ffffff'
	add_column :configurations, :string, :secondary_button3_fg, default: '#ffffff'
	add_column :configurations, :string, :secondary_button4_fg, default: '#ffffff'

	add_column :configurations, :integer, :secondary_button1_x, default: 237
	add_column :configurations, :integer, :secondary_button1_y, default: 698
	add_column :configurations, :integer, :secondary_button1_w, default: 100
	add_column :configurations, :integer, :secondary_button1_h, default: 40

	add_column :configurations, :integer, :secondary_button2_x, default: 387
	add_column :configurations, :integer, :secondary_button2_y, default: 698
	add_column :configurations, :integer, :secondary_button2_w, default: 100
	add_column :configurations, :integer, :secondary_button2_h, default: 40

	add_column :configurations, :integer, :secondary_button3_x, default: 537
	add_column :configurations, :integer, :secondary_button3_y, default: 698
	add_column :configurations, :integer, :secondary_button3_w, default: 100
	add_column :configurations, :integer, :secondary_button3_h, default: 40

	add_column :configurations, :integer, :secondary_button4_x, default: 687
	add_column :configurations, :integer, :secondary_button4_y, default: 698
	add_column :configurations, :integer, :secondary_button4_w, default: 100
	add_column :configurations, :integer, :secondary_button4_h, default: 40

  end
end
