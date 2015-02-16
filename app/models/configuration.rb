# == Schema Information
#
# Table name: configurations
#
#  id                              :integer          not null, primary key
#  participant_id                  :integer          not null
#  name                            :string           not null
#  enabled                         :boolean          default("true"), not null
#  is_practice                     :boolean          default("false"), not null
#  position                        :integer          default("0"), not null
#  days_of_week                    :string           default("---\n- monday\n- tuesday\n- wednesday\n- thursday\n- friday\n- saturday\n- sunday\n"), not null
#  image_set_id                    :integer          not null
#  loop_animations                 :boolean          default("false"), not null
#  animation_frame_rate            :integer
#  use_staircase_method            :boolean          default("false"), not null
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
#  background_colour               :string           default("#000000"), not null
#  show_exit_button                :boolean          default("true"), not null
#  exit_button_x                   :integer          default("994")
#  exit_button_y                   :integer          default("30")
#  exit_button_w                   :integer          default("30")
#  exit_button_h                   :integer          default("30")
#  exit_button_bg                  :string           default("#6c6c6c")
#  exit_button_fg                  :string           default("#ffffff")
#  num_buttons                     :integer          default("1")
#  button1_text                    :string
#  button2_text                    :string
#  button3_text                    :string
#  button4_text                    :string
#  button_presentation_delay       :float            default("0.0"), not null
#  button1_bg                      :string           default("#6c6c6c")
#  button2_bg                      :string           default("#6c6c6c")
#  button3_bg                      :string           default("#6c6c6c")
#  button4_bg                      :string           default("#6c6c6c")
#  button1_fg                      :string           default("#ffffff")
#  button2_fg                      :string           default("#ffffff")
#  button3_fg                      :string           default("#ffffff")
#  button4_fg                      :string           default("#ffffff")
#  button1_x                       :integer          default("237")
#  button1_y                       :integer          default("698")
#  button1_w                       :integer          default("100")
#  button1_h                       :integer          default("40")
#  button2_x                       :integer          default("387")
#  button2_y                       :integer          default("698")
#  button2_w                       :integer          default("100")
#  button2_h                       :integer          default("40")
#  button3_x                       :integer          default("537")
#  button3_y                       :integer          default("698")
#  button3_w                       :integer          default("100")
#  button3_h                       :integer          default("40")
#  button4_x                       :integer          default("687")
#  button4_y                       :integer          default("698")
#  button4_w                       :integer          default("100")
#  button4_h                       :integer          default("40")
#  require_next                    :boolean          default("false"), not null
#  time_between_question_mean      :float            default("0.0"), not null
#  time_between_question_plusminus :float            default("0.0"), not null
#  infinite_presentation_time      :boolean          default("true"), not null
#  finite_presentation_time        :float
#  infinite_response_window        :boolean          default("true"), not null
#  finite_response_window          :float
#  use_specified_seed              :boolean          default("false"), not null
#  specified_seed                  :string
#  attempt_facial_recognition      :boolean          default("false"), not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

class Configuration < ActiveRecord::Base
  extend Enumerize

  belongs_to :participant
  belongs_to :image_set

  serialize :days_of_week, Array
  enumerize :days_of_week, in: [:monday,
                                :tuesday,
                                :wednesday,
                                :thursday,
                                :friday,
                                :saturday,
                                :sunday], multiple: true

  enumerize :num_buttons, in: [1, 2, 3, 4]

  scope :non_practice_configurations, -> { where(is_practice: false) }
  scope :practice_configurations, -> { where(is_practice: true) }

  validates_presence_of :name
  validates_presence_of :image_set

  validates :number_of_staircases, if: :use_staircase_method, presence: true, numericality: { greater_than: 0 }
  validates :start_level, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :number_of_reversals, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :hits_to_finish, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :minimum_level, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :maximum_level, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :delta_values, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :num_wrong_to_get_easier, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :num_correct_to_get_harder, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }

  validates :questions_per_folder, unless: :use_staircase_method, presence: true, colon_comma_separated: true

  validates :background_colour, hex_color: true, presence: true

  validates :exit_button_x, if: :show_exit_button, presence: true
  validates :exit_button_y, if: :show_exit_button, presence: true
  validates :exit_button_w, if: :show_exit_button, presence: true, numericality: { greater_than: 0 }
  validates :exit_button_h, if: :show_exit_button, presence: true, numericality: { greater_than: 0 }

  validates :exit_button_bg, if: :show_exit_button, hex_color: true, presence: true
  validates :exit_button_fg, if: :show_exit_button, hex_color: true, presence: true

  # allow blank buttons
  #validates :button1_text, presence: true, if: Proc.new { |a| a.num_buttons.to_i >= 1 }
  #validates :button2_text, presence: true, if: Proc.new { |a| a.num_buttons.to_i >= 2 }
  #validates :button3_text, presence: true, if: Proc.new { |a| a.num_buttons.to_i >= 3 }
  #validates :button4_text, presence: true, if: Proc.new { |a| a.num_buttons.to_i >= 4 }

  validates :button_presentation_delay, numericality: { greater_than_or_equal_to: 0 }

  validates :button1_bg, presence: true, hex_color: true, if: Proc.new { |a| a.num_buttons.to_i >= 1 }
  validates :button1_fg, presence: true, hex_color: true, if: Proc.new { |a| a.num_buttons.to_i >= 1 }
  validates :button1_x, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 1 }
  validates :button1_y, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 1 }
  validates :button1_w, presence: true, numericality: { greater_than: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 1 }
  validates :button1_h, presence: true, numericality: { greater_than: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 1 }

  validates :button2_bg, presence: true, hex_color: true, if: Proc.new { |a| a.num_buttons.to_i >= 2 }
  validates :button2_fg, presence: true, hex_color: true, if: Proc.new { |a| a.num_buttons.to_i >= 2 }
  validates :button2_x, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 2 }
  validates :button2_y, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 2 }
  validates :button2_w, presence: true, numericality: { greater_than: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 2 }
  validates :button2_h, presence: true, numericality: { greater_than: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 2 }

  validates :button3_bg, presence: true, hex_color: true, if: Proc.new { |a| a.num_buttons.to_i >= 3 }
  validates :button3_fg, presence: true, hex_color: true, if: Proc.new { |a| a.num_buttons.to_i >= 3 }
  validates :button3_x, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 3 }
  validates :button3_y, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 3 }
  validates :button3_w, presence: true, numericality: { greater_than: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 3 }
  validates :button3_h, presence: true, numericality: { greater_than: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 3 }

  validates :button4_bg, presence: true, hex_color: true, if: Proc.new { |a| a.num_buttons.to_i >= 4 }
  validates :button4_fg, presence: true, hex_color: true, if: Proc.new { |a| a.num_buttons.to_i >= 4 }
  validates :button4_x, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 4 }
  validates :button4_y, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 4 }
  validates :button4_w, presence: true, numericality: { greater_than: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 4 }
  validates :button4_h, presence: true, numericality: { greater_than: 0 }, if: Proc.new { |a| a.num_buttons.to_i >= 4 }

  validates :finite_presentation_time, presence: true, numericality: { greater_than: 0 }, unless: :infinite_presentation_time
  validates :finite_response_window, presence: true, numericality: { greater_than: 0 }, unless: :infinite_response_window

  validates :specified_seed, presence: true, if: :use_specified_seed

end
