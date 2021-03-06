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

class GalleryConfiguration < Configuration

  belongs_to :user, required: true

  scope :public_configurations, -> { where(user: User.first) }
  scope :private_configurations, -> { where.not(user: User.first) }

  # this is shown in <select>s
  def display_name
    s = name
    if user == User.first
      s = '[Public] ' + s
    end
    s
  end

  def url
    Rails.application.routes.url_helpers.api_configuration_path(self) + '?' + self.updated_at.to_i.to_s
  end

end
