ActiveAdmin.register Configuration do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

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

  form do |f|

    f.semantic_errors *f.object.errors.keys

    f.inputs 'General Settings' do
      f.input :name, hint: 'This will appear to participants before starting the test'
      f.input :enabled, as: :radio_boolean
      f.input :is_practice, as: :radio_boolean, label: 'Is practice configuration'
      f.input :position, label: 'Order', hint: 'Assign each test a different order number to determine sequence of tests (does not need to be consecutive)'

      f.input :days_of_week, as: :check_boxes, label: 'Days of week this<br>configuration is enabled'.html_safe
    end

    f.inputs 'Image Sequences' do
      f.input :image_set,
              as: :select_link,
              link_url: admin_image_sets_path,
              link_text: 'Manage image sequences',
              label: 'Image sequence'
      f.input :loop_animations, as: :radio_boolean
      f.input :animation_frame_rate, hint: 'Milliseconds per frame = <b>frame rate</b> / 60'.html_safe
    end

    f.inputs 'Staircase Method Parameters' do
      f.input :use_staircase_method, as: :radio_boolean
      f.input :number_of_staircases
      f.li 'The following fields take multiple values, one per each staircase, separated by a forward slash (/).'
      f.input :start_level
      f.input :number_of_reversals
      f.input :hits_to_finish, label: 'Floor/ceiling hits to finish'
      f.input :minimum_level
      f.input :maximum_level
      f.input :delta_values, label: '∆ values'
      f.input :num_wrong_to_get_easier, label: '# wrong to get easier'
      f.input :num_correct_to_get_harder, label: '# correct to get harder'
    end

    f.inputs 'Method of Constant Stimuli (MOCS) Parameters' do
      f.li 'Follow the pattern <i>&lt;level&gt;:&lt;count&gt;,&lt;level&gt;:&lt;count&gt;</i>... where <i>&lt;level&gt;</i> refers to the folder names and <i>&lt;count&gt;</i> refers to the number of images to show from that folder.'.html_safe
      f.input :questions_per_folder, label: '# questions per folder'
    end

    f.inputs 'Display Configuration' do
      f.input :background_colour, input_html: { class: 'colorpicker' }
      f.input :show_exit_button, as: :radio_boolean

      f.li 'Positions are in \'points\' in the range of 1024x768 which will be scaled to the iPad resolution (1024x768 for non-retina, 2048x1536 for retina).'

      f.input 'Exit button position', as: :multiple_numbers, fields:
                                     [['X:',      :exit_button_x],
                                      ['Y:',      :exit_button_y],
                                      ['Width:',  :exit_button_w],
                                      ['Height:', :exit_button_h]]

      f.input 'Exit button colour', as: :multiple_strings, input_html: { class: 'colorpicker' }, fields:
                                      [['Background:', :exit_button_bg],
                                       ['Cross colour:', :exit_button_fg]]
    end

    f.inputs 'Button Configuration' do
      f.input :num_buttons, label: 'Number of buttons', as: :radio

      f.input 'Button text', as: :multiple_strings, fields:
                               [['1:', :button1_text],
                                ['2:', :button2_text],
                                ['3:', :button3_text],
                                ['4:', :button4_text]]

      f.input :button_presentation_delay, label: 'Button presentation<br>delay (s)'.html_safe, wrapper_html: { class: 'two_line' }

      f.input 'Button backgrounds', as: :multiple_strings, input_html: { class: 'colorpicker' }, fields:
                               [['1:', :button1_bg],
                                ['2:', :button2_bg],
                                ['3:', :button3_bg],
                                ['4:', :button4_bg]]

      f.input 'Button text colours', as: :multiple_strings, input_html: { class: 'colorpicker' }, fields:
                                      [['1:', :button1_fg],
                                       ['2:', :button2_fg],
                                       ['3:', :button3_fg],
                                       ['4:', :button4_fg]]

      f.li 'Positions are in \'points\' in the range of 1024x768 which will be scaled to the iPad resolution (1024x768 for non-retina, 2048x1536 for retina).'

      f.input 'Button 1 position', as: :multiple_numbers, fields:
                                     [['X:',      :button1_x],
                                      ['Y:',      :button1_y],
                                      ['Width:',  :button1_w],
                                      ['Height:', :button1_h]]

      f.input 'Button 2 position', as: :multiple_numbers, fields:
                                     [['X:',      :button2_x],
                                      ['Y:',      :button2_y],
                                      ['Width:',  :button2_w],
                                      ['Height:', :button2_h]]

      f.input 'Button 3 position', as: :multiple_numbers, fields:
                                     [['X:',      :button3_x],
                                      ['Y:',      :button3_y],
                                      ['Width:',  :button3_w],
                                      ['Height:', :button3_h]]

      f.input 'Button 4 position', as: :multiple_numbers, fields:
                                     [['X:',      :button4_x],
                                      ['Y:',      :button4_y],
                                      ['Width:',  :button4_w],
                                      ['Height:', :button4_h]]
    end

    f.inputs 'General Test Parameters' do
      f.input :require_next, as: :radio_boolean, label: '[next] button after<br>each response'.html_safe, wrapper_html: { class: 'two_line' }

      f.input 'Time between<br>each question (s)'.html_safe, step: 0.01, as: :multiple_numbers, wrapper_html: { class: 'two_line' }, fields:
                                             [['Mean:',      :time_between_question_mean],
                                              ['± variation:',      :time_between_question_plusminus]],
              hint: 'A uniform distribution is used with the given mean and range.'

      f.input :infinite_presentation_time, as: :radio_boolean
      f.input :finite_presentation_time, step: 0.01, label: 'Presentation time if<br>not infinite (s)'.html_safe, wrapper_html: { class: 'two_line' },
              hint: 'Images will disappear after the specified time, though buttons can still be pressed afterwards.'

      f.input :infinite_response_window, as: :radio_boolean
      f.input :finite_response_window, step: 0.01, label: 'Response window if<br>not infinite (s)'.html_safe, wrapper_html: { class: 'two_line' },
              hint: 'If a button is not pressed within the response window, a response_window_timeout will be logged.<br>For staircases this is treated as an incorrect response.'.html_safe

      f.input :use_specified_seed, as: :radio_boolean, hint: 'A specified seed will allow you to perform repeatable tests or re-run a test with a seed given in a log file.'
      f.input :specified_seed

      f.input :attempt_facial_recognition, as: :radio_boolean
    end

    f.actions
  end

end
