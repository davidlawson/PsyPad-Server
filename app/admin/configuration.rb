ActiveAdmin.register Configuration do

  permit_params :name,
                :enabled,
                :is_practice,
                :position,
                :days_of_week,
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
                :button1_text,
                :button2_text,
                :button3_text,
                :button4_text,
                :button_presentation_delay,
                :button1_bg,
                :button2_bg,
                :button3_bg,
                :button4_bg,
                :button1_fg,
                :button2_fg,
                :button3_fg,
                :button4_fg,
                :button1_x,
                :button1_y,
                :button1_w,
                :button1_h,
                :button2_x,
                :button2_y,
                :button2_w,
                :button2_h,
                :button3_x,
                :button3_y,
                :button3_w,
                :button3_h,
                :button4_x,
                :button4_y,
                :button4_w,
                :button4_h,
                :require_next,
                :time_between_question_mean,
                :time_between_question_plusminus,
                :infinite_presentation_time,
                :finite_presentation_time,
                :infinite_response_window,
                :finite_response_window,
                :use_specified_seed,
                :specified_seed,
                :attempt_facial_recognition

  belongs_to :participant
  navigation_menu :default
  menu false

  filter :name
  filter :enabled
  filter :is_practice
  filter :image_set
  filter :created_at
  filter :updated_at

  # scope :all, default: true
  # scope :non_practice_configurations
  # scope :practice_configurations

  index do
    selectable_column
    column :name
    column :enabled
    column :is_practice
    column :image_set
    column :position
    column :created_at
    column :updated_at
    actions defaults: true do |configuration|
      link_to 'Clone', clone_admin_participant_configuration_path(participant, configuration)
    end
  end

  member_action :clone, method: :get do
    @configuration = resource.dup
    render :new, layout: false
  end

  action_item :only => :show do
    link_to 'Clone Configuration', clone_admin_participant_configuration_path(participant, configuration)
  end

  # /app/views/admin/configurations/_form.html.arb
  form partial: 'form'

  # /app/views/admin/configurations/_show.html.arb
  show do
    render 'show'
  end

end
