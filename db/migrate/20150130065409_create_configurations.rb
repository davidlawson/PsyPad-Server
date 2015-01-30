class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|

      t.belongs_to :participant, index: true

      t.string :name, null: false
      t.boolean :enabled, default: true
      t.boolean :is_practice, default: false
      t.integer :position

      t.boolean :monday,    default: true
      t.boolean :tuesday,   default: true
      t.boolean :wednesday, default: true
      t.boolean :thursday,  default: true
      t.boolean :friday,    default: true
      t.boolean :saturday,  default: true
      t.boolean :sunday,    default: true

      t.belongs_to :image_set, index: true
      t.boolean :loop_animations, default: false
      t.integer :animation_frame_rate

      t.boolean :use_staircase_method, default: false
      t.integer :number_of_staircases
      t.string :start_level
      t.string :number_of_reversals
      t.string :hits_to_finish
      t.string :minimum_level
      t.string :maximum_level
      t.string :delta_values
      t.string :num_wrong_to_get_easier
      t.string :num_correct_to_get_harder

      t.string :questions_per_folder

      t.string :background_colour
      t.boolean :show_exit_button
      t.integer :exit_button_x
      t.integer :exit_button_y
      t.integer :exit_button_w
      t.integer :exit_button_h
      t.string :exit_button_bg
      t.string :exit_button_fg

      t.integer :num_buttons

      t.string :button1_text
      t.string :button2_text
      t.string :button3_text
      t.string :button4_text

      t.float :button_presentation_delay

      t.string :button1_bg
      t.string :button2_bg
      t.string :button3_bg
      t.string :button4_bg

      t.string :button1_fg
      t.string :button2_fg
      t.string :button3_fg
      t.string :button4_fg

      t.integer :button1_x
      t.integer :button1_y
      t.integer :button1_w
      t.integer :button1_h

      t.integer :button2_x
      t.integer :button2_y
      t.integer :button2_w
      t.integer :button2_h

      t.integer :button3_x
      t.integer :button3_y
      t.integer :button3_w
      t.integer :button3_h

      t.integer :button4_x
      t.integer :button4_y
      t.integer :button4_w
      t.integer :button4_h

      t.boolean :require_next

      t.float :time_between_question_mean
      t.float :time_between_question_plusminus

      t.boolean :infinite_presentation_time
      t.float :finite_presentation_time

      t.boolean :infinite_response_window
      t.float :finite_response_window

      t.boolean :use_specified_seed
      t.string :specified_seed

      t.boolean :attempt_facial_recognition

      t.timestamps null: false

    end
  end
end
