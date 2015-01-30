# == Schema Information
#
# Table name: configurations
#
#  id                              :integer          not null, primary key
#  participant_id                  :integer
#  name                            :string           not null
#  enabled                         :boolean          default("true")
#  is_practice                     :boolean          default("false")
#  position                        :integer
#  monday                          :boolean          default("true")
#  tuesday                         :boolean          default("true")
#  wednesday                       :boolean          default("true")
#  thursday                        :boolean          default("true")
#  friday                          :boolean          default("true")
#  saturday                        :boolean          default("true")
#  sunday                          :boolean          default("true")
#  image_set_id                    :integer
#  loop_animations                 :boolean          default("false")
#  animation_frame_rate            :integer
#  use_staircase_method            :boolean          default("false")
#  number_of_staircases            :integer
#  start_level                     :string
#  number_of_reversals             :string
#  hits_to_finish                  :string
#  minimum_level                   :string
#  maximum_level                   :string
#  delta_values                    :string
#  num_wrong_to_get_easier         :string
#  num_correct_to_get_harder       :string
#  questions_per_folder            :string
#  background_colour               :string
#  show_exit_button                :boolean
#  exit_button_x                   :integer
#  exit_button_y                   :integer
#  exit_button_w                   :integer
#  exit_button_h                   :integer
#  exit_button_bg                  :string
#  exit_button_fg                  :string
#  num_buttons                     :integer
#  button1_text                    :string
#  button2_text                    :string
#  button3_text                    :string
#  button4_text                    :string
#  button_presentation_delay       :float
#  button1_bg                      :string
#  button2_bg                      :string
#  button3_bg                      :string
#  button4_bg                      :string
#  button1_fg                      :string
#  button2_fg                      :string
#  button3_fg                      :string
#  button4_fg                      :string
#  button1_x                       :integer
#  button1_y                       :integer
#  button1_w                       :integer
#  button1_h                       :integer
#  button2_x                       :integer
#  button2_y                       :integer
#  button2_w                       :integer
#  button2_h                       :integer
#  button3_x                       :integer
#  button3_y                       :integer
#  button3_w                       :integer
#  button3_h                       :integer
#  button4_x                       :integer
#  button4_y                       :integer
#  button4_w                       :integer
#  button4_h                       :integer
#  require_next                    :boolean
#  time_between_question_mean      :float
#  time_between_question_plusminus :float
#  infinite_presentation_time      :boolean
#  finite_presentation_time        :float
#  infinite_response_window        :boolean
#  finite_response_window          :float
#  use_specified_seed              :boolean
#  specified_seed                  :string
#  attempt_facial_recognition      :boolean
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

class Configuration < ActiveRecord::Base

  belongs_to :image_set

end
