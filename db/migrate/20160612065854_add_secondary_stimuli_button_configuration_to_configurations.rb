class AddSecondaryStimuliButtonConfigurationToConfigurations < ActiveRecord::Migration
  def change

	add_column :configurations, :num_secondary_buttons, :integer, default: 4

	add_column :configurations, :secondary_button1_text, :string
	add_column :configurations, :secondary_button2_text, :string
	add_column :configurations, :secondary_button3_text, :string
	add_column :configurations, :secondary_button4_text, :string

	add_column :configurations, :secondary_button1_bg, :string, default: '#6c6c6c'
	add_column :configurations, :secondary_button2_bg, :string, default: '#6c6c6c'
	add_column :configurations, :secondary_button3_bg, :string, default: '#6c6c6c'
	add_column :configurations, :secondary_button4_bg, :string, default: '#6c6c6c'

	add_column :configurations, :secondary_button1_fg, :string, default: '#ffffff'
	add_column :configurations, :secondary_button2_fg, :string, default: '#ffffff'
	add_column :configurations, :secondary_button3_fg, :string, default: '#ffffff'
	add_column :configurations, :secondary_button4_fg, :string, default: '#ffffff'

	add_column :configurations, :secondary_button1_x, :integer, default: 237
	add_column :configurations, :secondary_button1_y, :integer, default: 698
	add_column :configurations, :secondary_button1_w, :integer, default: 100
	add_column :configurations, :secondary_button1_h, :integer, default: 40

	add_column :configurations, :secondary_button2_x, :integer, default: 387
	add_column :configurations, :secondary_button2_y, :integer, default: 698
	add_column :configurations, :secondary_button2_w, :integer, default: 100
	add_column :configurations, :secondary_button2_h, :integer, default: 40

	add_column :configurations, :secondary_button3_x, :integer, default: 537
	add_column :configurations, :secondary_button3_y, :integer, default: 698
	add_column :configurations, :secondary_button3_w, :integer, default: 100
	add_column :configurations, :secondary_button3_h, :integer, default: 40

	add_column :configurations, :secondary_button4_x, :integer, default: 687
	add_column :configurations, :secondary_button4_y, :integer, default: 698
	add_column :configurations, :secondary_button4_w, :integer, default: 100
	add_column :configurations, :secondary_button4_h, :integer, default: 40

  end
end
