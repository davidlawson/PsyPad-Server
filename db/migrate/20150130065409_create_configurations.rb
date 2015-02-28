class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|

      t.belongs_to :user, index: true
      t.belongs_to :participant, index: true

      t.string :type, null: false

      t.string :name, null: false
      t.string :title
      t.boolean :enabled, default: true, null: false
      t.boolean :is_practice, default: false, null: false
      t.integer :position, default: 0, null: false

      t.string :days_of_week, default:
            "---\n" +
            "- monday\n" +
            "- tuesday\n" +
            "- wednesday\n" +
            "- thursday\n" +
            "- friday\n" +
            "- saturday\n" +
            "- sunday\n", null: false

      t.belongs_to :image_set, index: true, null: false
      t.boolean :loop_animations, default: false, null: false
      t.integer :animation_frame_rate

      t.boolean :use_staircase_method, default: false, null: false
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

      t.string :background_colour, default: '#000000', null: false
      t.boolean :show_exit_button, default: true, null: false
      t.integer :exit_button_x, default: 994
      t.integer :exit_button_y, default: 30
      t.integer :exit_button_w, default: 30
      t.integer :exit_button_h, default: 30
      t.string :exit_button_bg, default: '#6c6c6c'
      t.string :exit_button_fg, default: '#ffffff'

      t.integer :num_buttons, default: 1

      t.string :button1_text
      t.string :button2_text
      t.string :button3_text
      t.string :button4_text

      t.float :button_presentation_delay, default: 0, null: false

      t.string :button1_bg, default: '#6c6c6c'
      t.string :button2_bg, default: '#6c6c6c'
      t.string :button3_bg, default: '#6c6c6c'
      t.string :button4_bg, default: '#6c6c6c'

      t.string :button1_fg, default: '#ffffff'
      t.string :button2_fg, default: '#ffffff'
      t.string :button3_fg, default: '#ffffff'
      t.string :button4_fg, default: '#ffffff'

      t.integer :button1_x, default: 237
      t.integer :button1_y, default: 698
      t.integer :button1_w, default: 100
      t.integer :button1_h, default: 40

      t.integer :button2_x, default: 387
      t.integer :button2_y, default: 698
      t.integer :button2_w, default: 100
      t.integer :button2_h, default: 40

      t.integer :button3_x, default: 537
      t.integer :button3_y, default: 698
      t.integer :button3_w, default: 100
      t.integer :button3_h, default: 40

      t.integer :button4_x, default: 687
      t.integer :button4_y, default: 698
      t.integer :button4_w, default: 100
      t.integer :button4_h, default: 40

      t.boolean :require_next, default: false, null: false

      t.float :time_between_question_mean, default: 0, null: false
      t.float :time_between_question_plusminus, default: 0, null: false

      t.boolean :infinite_presentation_time, default: true, null: false
      t.float :finite_presentation_time

      t.boolean :infinite_response_window, default: true, null: false
      t.float :finite_response_window

      t.boolean :use_specified_seed, default: false, null: false
      t.string :specified_seed

      t.boolean :attempt_facial_recognition, default: false, null: false

      t.timestamps null: false

    end
  end
end
