@configuration = configuration unless @configuration.present?

json.name @configuration.name
json.title @configuration.title
json.configuration_description @configuration.description

json.enabled @configuration.enabled
json.is_practice @configuration.is_practice
json.is_gallery_configuration @configuration.instance_of?(GalleryConfiguration)

json.day_of_week_mon @configuration.days_of_week.include?(:monday)
json.day_of_week_tue @configuration.days_of_week.include?(:tuesday)
json.day_of_week_wed @configuration.days_of_week.include?(:wednesday)
json.day_of_week_thu @configuration.days_of_week.include?(:thursday)
json.day_of_week_fri @configuration.days_of_week.include?(:friday)
json.day_of_week_sat @configuration.days_of_week.include?(:saturday)
json.day_of_week_sun @configuration.days_of_week.include?(:sunday)

json.image_set_url @configuration.image_set.url
json.image_set_data do
  offset = 0

  if @configuration.image_set.background_image_path.present?
    json.bg_l @configuration.image_set.background_image_size
    json.bg_s offset
    offset += @configuration.image_set.background_image_size
  end

  if @configuration.image_set.title_image_path.present?
    json.t_l @configuration.image_set.title_image_size
    json.t_s offset
    offset += @configuration.image_set.title_image_size
  end

  if @configuration.image_set.correct_wav_path.present?
    json.c_l @configuration.image_set.correct_wav_size
    json.c_s offset
    offset += @configuration.image_set.correct_wav_size
  end

  if @configuration.image_set.incorrect_wav_path.present?
    json.i_l @configuration.image_set.incorrect_wav_size
    json.i_s offset
    offset += @configuration.image_set.incorrect_wav_size
  end

  if @configuration.image_set.on_wav_path.present?
    json.on_l @configuration.image_set.on_wav_size
    json.on_s offset
    offset += @configuration.image_set.on_wav_size
  end

  if @configuration.image_set.off_wav_path.present?
    json.off_l @configuration.image_set.off_wav_size
    json.off_s offset
    offset += @configuration.image_set.off_wav_size
  end

  if @configuration.image_set.timeout_wav_path.present?
    json.to_l @configuration.image_set.timeout_wav_size
    json.to_s offset
    offset += @configuration.image_set.timeout_wav_size
  end

  if @configuration.image_set.button1_image_path.present?
    json.b1_l @configuration.image_set.button1_image_size
    json.b1_s offset
    offset += @configuration.image_set.button1_image_size
  end

  if @configuration.image_set.button2_image_path.present?
    json.b2_l @configuration.image_set.button2_image_size
    json.b2_s offset
    offset += @configuration.image_set.button2_image_size
  end

  if @configuration.image_set.button3_image_path.present?
    json.b3_l @configuration.image_set.button3_image_size
    json.b3_s offset
    offset += @configuration.image_set.button3_image_size
  end

  if @configuration.image_set.button4_image_path.present?
    json.b4_l @configuration.image_set.button4_image_size
    json.b4_s offset
    offset += @configuration.image_set.button4_image_size
  end

  if @configuration.image_set.secondary_button1_image_path.present?
    json.sb1_l @configuration.image_set.secondary_button1_image_size
    json.sb1_s offset
    offset += @configuration.image_set.secondary_button1_image_size
  end

  if @configuration.image_set.secondary_button2_image_path.present?
    json.sb2_l @configuration.image_set.secondary_button2_image_size
    json.sb2_s offset
    offset += @configuration.image_set.secondary_button2_image_size
  end

  if @configuration.image_set.secondary_button3_image_path.present?
    json.sb3_l @configuration.image_set.secondary_button3_image_size
    json.sb3_s offset
    offset += @configuration.image_set.secondary_button3_image_size
  end

  if @configuration.image_set.secondary_button4_image_path.present?
    json.sb4_l @configuration.image_set.secondary_button4_image_size
    json.sb4_s offset
    offset += @configuration.image_set.secondary_button4_image_size
  end

  json.g @configuration.image_set.image_groups.order(name: :asc) do |group|
    json.n group.name
    json.i group.images.order(name: :asc) do |image|
      json.n image.name
      json.a image.animated
      json.f image.image_frames.order(frame_name: :asc) do |frame|
        json.n frame.frame_name
        json.l frame.frame_size
        json.s offset
        offset += frame.frame_size
      end
    end
  end
end

json.loop_animations @configuration.loop_animations
json.animation_frame_rate @configuration.animation_frame_rate

json.use_staircase_method @configuration.use_staircase_method
json.number_of_staircases @configuration.number_of_staircases
json.start_level @configuration.start_level
json.number_of_reversals @configuration.number_of_reversals
json.hits_to_finish @configuration.hits_to_finish
json.minimum_level @configuration.minimum_level
json.maximum_level @configuration.maximum_level
json.delta_values @configuration.delta_values
json.num_wrong_to_get_easier @configuration.num_wrong_to_get_easier
json.num_correct_to_get_harder @configuration.num_correct_to_get_harder

json.questions_per_folder @configuration.questions_per_folder

json.background_colour @configuration.background_colour

json.show_exit_button @configuration.show_exit_button
json.exit_button_bg @configuration.exit_button_bg
json.exit_button_fg @configuration.exit_button_fg
json.exit_button_h @configuration.exit_button_h
json.exit_button_w @configuration.exit_button_w
json.exit_button_x @configuration.exit_button_x
json.exit_button_y @configuration.exit_button_y

json.num_buttons @configuration.num_buttons
json.button_presentation_delay @configuration.button_presentation_delay

json.button1_bg @configuration.button1_bg
json.button1_fg @configuration.button1_fg
json.button1_h @configuration.button1_h
json.button1_text @configuration.button1_text
json.button1_w @configuration.button1_w
json.button1_x @configuration.button1_x
json.button1_y @configuration.button1_y

json.button2_bg @configuration.button2_bg
json.button2_fg @configuration.button2_fg
json.button2_h @configuration.button2_h
json.button2_text @configuration.button2_text
json.button2_w @configuration.button2_w
json.button2_x @configuration.button2_x
json.button2_y @configuration.button2_y

json.button3_bg @configuration.button3_bg
json.button3_fg @configuration.button3_fg
json.button3_h @configuration.button3_h
json.button3_text @configuration.button3_text
json.button3_w @configuration.button3_w
json.button3_x @configuration.button3_x
json.button3_y @configuration.button3_y

json.button4_bg @configuration.button4_bg
json.button4_fg @configuration.button4_fg
json.button4_h @configuration.button4_h
json.button4_text @configuration.button4_text
json.button4_w @configuration.button4_w
json.button4_x @configuration.button4_x
json.button4_y @configuration.button4_y

json.num_secondary_buttons @configuration.num_secondary_buttons

json.secondary_button1_bg @configuration.secondary_button1_bg
json.secondary_button1_fg @configuration.secondary_button1_fg
json.secondary_button1_h @configuration.secondary_button1_h
json.secondary_button1_text @configuration.secondary_button1_text
json.secondary_button1_w @configuration.secondary_button1_w
json.secondary_button1_x @configuration.secondary_button1_x
json.secondary_button1_y @configuration.secondary_button1_y

json.secondary_button2_bg @configuration.secondary_button2_bg
json.secondary_button2_fg @configuration.secondary_button2_fg
json.secondary_button2_h @configuration.secondary_button2_h
json.secondary_button2_text @configuration.secondary_button2_text
json.secondary_button2_w @configuration.secondary_button2_w
json.secondary_button2_x @configuration.secondary_button2_x
json.secondary_button2_y @configuration.secondary_button2_y

json.secondary_button3_bg @configuration.secondary_button3_bg
json.secondary_button3_fg @configuration.secondary_button3_fg
json.secondary_button3_h @configuration.secondary_button3_h
json.secondary_button3_text @configuration.secondary_button3_text
json.secondary_button3_w @configuration.secondary_button3_w
json.secondary_button3_x @configuration.secondary_button3_x
json.secondary_button3_y @configuration.secondary_button3_y

json.secondary_button4_bg @configuration.secondary_button4_bg
json.secondary_button4_fg @configuration.secondary_button4_fg
json.secondary_button4_h @configuration.secondary_button4_h
json.secondary_button4_text @configuration.secondary_button4_text
json.secondary_button4_w @configuration.secondary_button4_w
json.secondary_button4_x @configuration.secondary_button4_x
json.secondary_button4_y @configuration.secondary_button4_y

json.require_next @configuration.require_next

json.time_between_question_mean @configuration.time_between_question_mean
json.time_between_question_plusminus @configuration.time_between_question_plusminus

json.infinite_presentation_time @configuration.infinite_presentation_time
json.finite_presentation_time @configuration.finite_presentation_time

json.infinite_response_window @configuration.infinite_response_window
json.finite_response_window @configuration.finite_response_window

json.use_specified_seed @configuration.use_specified_seed
json.specified_seed @configuration.specified_seed

json.attempt_facial_recognition @configuration.attempt_facial_recognition

json.enable_secondary_stimuli @configuration.enable_secondary_stimuli

@configuration = nil
