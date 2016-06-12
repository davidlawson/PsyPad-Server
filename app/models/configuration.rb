# == Schema Information
#
# Table name: configurations
#
#  id                              :integer          not null, primary key
#  user_id                         :integer
#  participant_id                  :integer
#  type                            :string           not null
#  name                            :string           not null
#  title                           :string
#  enabled                         :boolean          default(TRUE), not null
#  is_practice                     :boolean          default(FALSE), not null
#  position                        :integer          default(0), not null
#  days_of_week                    :string           default(["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]), not null
#  image_set_id                    :integer          not null
#  loop_animations                 :boolean          default(FALSE), not null
#  animation_frame_rate            :integer
#  use_staircase_method            :boolean          default(FALSE), not null
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
#  show_exit_button                :boolean          default(TRUE), not null
#  exit_button_x                   :integer          default(994)
#  exit_button_y                   :integer          default(30)
#  exit_button_w                   :integer          default(30)
#  exit_button_h                   :integer          default(30)
#  exit_button_bg                  :string           default("#6c6c6c")
#  exit_button_fg                  :string           default("#ffffff")
#  num_buttons                     :integer          default(1)
#  button1_text                    :string
#  button2_text                    :string
#  button3_text                    :string
#  button4_text                    :string
#  button_presentation_delay       :float            default(0.0), not null
#  button1_bg                      :string           default("#6c6c6c")
#  button2_bg                      :string           default("#6c6c6c")
#  button3_bg                      :string           default("#6c6c6c")
#  button4_bg                      :string           default("#6c6c6c")
#  button1_fg                      :string           default("#ffffff")
#  button2_fg                      :string           default("#ffffff")
#  button3_fg                      :string           default("#ffffff")
#  button4_fg                      :string           default("#ffffff")
#  button1_x                       :integer          default(237)
#  button1_y                       :integer          default(698)
#  button1_w                       :integer          default(100)
#  button1_h                       :integer          default(40)
#  button2_x                       :integer          default(387)
#  button2_y                       :integer          default(698)
#  button2_w                       :integer          default(100)
#  button2_h                       :integer          default(40)
#  button3_x                       :integer          default(537)
#  button3_y                       :integer          default(698)
#  button3_w                       :integer          default(100)
#  button3_h                       :integer          default(40)
#  button4_x                       :integer          default(687)
#  button4_y                       :integer          default(698)
#  button4_w                       :integer          default(100)
#  button4_h                       :integer          default(40)
#  require_next                    :boolean          default(FALSE), not null
#  time_between_question_mean      :float            default(0.0), not null
#  time_between_question_plusminus :float            default(0.0), not null
#  infinite_presentation_time      :boolean          default(TRUE), not null
#  finite_presentation_time        :float
#  infinite_response_window        :boolean          default(TRUE), not null
#  finite_response_window          :float
#  use_specified_seed              :boolean          default(FALSE), not null
#  specified_seed                  :string
#  attempt_facial_recognition      :boolean          default(FALSE), not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  description                     :string
#

class Configuration < ActiveRecord::Base
  extend Enumerize

  # has_one (many-to-one)
  belongs_to :image_set, required: true

  serialize :days_of_week, Array
  enumerize :days_of_week, in: [:monday,
                                :tuesday,
                                :wednesday,
                                :thursday,
                                :friday,
                                :saturday,
                                :sunday], multiple: true

  enumerize :num_buttons, in: [1, 2, 3, 4]
  enumerize :num_secondary_buttons, in: [1, 2, 3, 4]

  scope :non_practice_configurations, -> { where(is_practice: false) }
  scope :practice_configurations, -> { where(is_practice: true) }

  def self.permitted_params
    [
        :name,
        :title,
        :description,
        :enabled,
        :is_practice,
        :position,
        :image_set_id,
        :loop_animations,
        :animation_frame_rate,
        :use_staircase_method,
        :number_of_staircases,
        :start_level,
        :number_of_reversals,
        :hits_to_finish,
        :minimum_level,
        :maximum_level,
        :delta_values,
        :num_wrong_to_get_easier,
        :num_correct_to_get_harder,
        :questions_per_folder,
        :background_colour,
        :show_exit_button,
        :exit_button_x,
        :exit_button_y,
        :exit_button_w,
        :exit_button_h,
        :exit_button_bg,
        :exit_button_fg,
        :num_buttons,
        :button1_text, :button2_text, :button3_text, :button4_text,
        :button_presentation_delay,
        :button1_bg, :button2_bg, :button3_bg, :button4_bg,
        :button1_fg, :button2_fg, :button3_fg, :button4_fg,
        :button1_x, :button1_y, :button1_w, :button1_h,
        :button2_x, :button2_y, :button2_w, :button2_h,
        :button3_x, :button3_y, :button3_w, :button3_h,
        :button4_x, :button4_y, :button4_w, :button4_h,
        :num_secondary_buttons,
        :secondary_button1_text, :secondary_button2_text, :secondary_button3_text, :secondary_button4_text,
        :secondary_button1_bg, :secondary_button2_bg, :secondary_button3_bg, :secondary_button4_bg,
        :secondary_button1_fg, :secondary_button2_fg, :secondary_button3_fg, :secondary_button4_fg,
        :secondary_button1_x, :secondary_button1_y, :secondary_button1_w, :secondary_button1_h,
        :secondary_button2_x, :secondary_button2_y, :secondary_button2_w, :secondary_button2_h,
        :secondary_button3_x, :secondary_button3_y, :secondary_button3_w, :secondary_button3_h,
        :secondary_button4_x, :secondary_button4_y, :secondary_button4_w, :secondary_button4_h,
        :require_next,
        :time_between_question_mean,
        :time_between_question_plusminus,
        :infinite_presentation_time,
        :finite_presentation_time,
        :infinite_response_window,
        :finite_response_window,
        :use_specified_seed,
        :specified_seed,
        :attempt_facial_recognition,
        :enable_secondary_stimuli,
        :days_of_week => []
    ]
  end

  validates_presence_of :name

  validates_presence_of :animation_frame_rate

  validates :number_of_staircases, if: :use_staircase_method, presence: true, numericality: { greater_than: 0 }
  validates :start_level, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :number_of_reversals, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :hits_to_finish, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :minimum_level, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :maximum_level, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :delta_values, if: :use_staircase_method, presence: true, slash_comma_separated: { slash: :number_of_staircases, comma: :number_of_reversals }
  validates :num_wrong_to_get_easier, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }
  validates :num_correct_to_get_harder, if: :use_staircase_method, presence: true, slash_separated: { count: :number_of_staircases }

  validates :questions_per_folder, unless: :use_staircase_method, presence: true, colon_comma_separated: true

  validate :valid_questions_per_folder, unless: :use_staircase_method

  def valid_questions_per_folder

    return if image_set.nil?

    not_found = []

    questions_per_folder.split(',').each do |item|

      level = item.split(':').first
      if image_set.image_groups.find_by_name(level).nil?
        not_found << level
      end

    end

    if not_found.count > 0
      errors[:questions_per_folder] << 'contains levels not in the selected image set: ' + not_found.join(', ')
    end

  end

  # TODO also sanity validate staircase values

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

  validates :finite_presentation_time, presence: true, numericality: { greater_than_or_equal_to: 0.001 }, unless: :infinite_presentation_time
  validates :finite_response_window, presence: true, numericality: { greater_than_or_equal_to: 0.001 }, unless: :infinite_response_window

  validates :specified_seed, presence: true, if: :use_specified_seed

end
