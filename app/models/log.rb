# == Schema Information
#
# Table name: logs
#
#  id             :integer          not null, primary key
#  participant_id :integer
#  test_date      :datetime         not null
#  content        :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#

class Log < ActiveRecord::Base

  belongs_to :user
  belongs_to :participant

  validates_presence_of :test_date
  validates_presence_of :content

  def send_to_external_server(url)

    success = false

    until success
      resp = Net::HTTP.post_form(URI(url), { event: 'log', participant: participant.username, content: content })
      success = (resp.code == 200)
      unless success
        logger.error "Failed to send log to external server (#{url})"
        sleep 10
      end
    end

  end

  def parsed_content
    content.scan(/([^|]+)\|([^|]+)\|([^\n]+)\n/m)
  end

  def parsed_configuration
    JSON.parse(parsed_content[0][2]) rescue nil
  end

  def configuration_name
    parsed_configuration['name'] rescue nil
  end

  def text_analysis
    out = ''

    # First determine if it is a staircase or MOCS
    # and record start and end times
    # Also record if it is a practice test
    # Note one question MOCS treated slightly differently from >1 question MOCS
    start_time = 0
    end_time = 0

    lines = parsed_content
    config = parsed_configuration

    if config.nil?
      return 'Could not process log file'
    end

    out << "Summary\n"
    out << "Test date: #{test_date.strftime('%e/%m/%Y %H:%M:%S')}\n"

    staircase_method = config['use_staircase_method']
    staircase_number = config['number_of_staircases']
    staircase_max_level = config['maximum_level']
    staircase_min_level = config['minimum_level']
    start_time = lines[0][0].to_i
    questions_per_folder = config['questions_per_folder'] # "1:1" for one question MOCS which probably indicates survey
    num_buttons = config['num_buttons']                   # need to handle yes/no differently for 1 button case

    out << config['name'] << "\n"
    if config['is_practice'] == 1
      out << "Practice: yes\n"
    else
      out << "Practice: no\n"
    end

    if lines.last[1] == 'exit_test' || lines.last[1] == 'test_finished'
      end_time = lines.last[0].to_i
    end

    # now record reversals for staircases, and % correct for MOCS
    if staircase_method == 1

      reversal_count = [] # indexed by staircase number
      reversal_value = [] # indexed by staircase number and reversal number
      seen_min = []       # indexed by staircase number
      not_seen_max = []   # indexed by staircase number
      min_stim = staircase_min_level.split('/') # indexed by staircase number
      max_stim = staircase_max_level.split('/') # indexed by staircase number

      for i in 0...staircase_number
        reversal_count[i] = 0
        seen_min[i] = 0
        not_seen_max[i] = 0
      end

      stair = 0
      stim = 0
      correct_button = 0

      lines.each do |line|

        if line[1] == 'currentStaircase' # record the current staricase
          stair = line[2].to_i
        end

        if line[1] == 'presented_image'
          # record the current stim value
          temp = line[2].split('/')
          stim = temp[0].to_i
          correct_button = temp[1][0].to_i
        end

        if line[1] == 'reversal'
          # record stim value at reversal
          reversal_value[stair] = reversal_value[stair] || []
          reversal_value[stair][reversal_count[stair]] = stim
          reversal_count[stair] += 1
        end

        if line[1] == 'button_press' && #min_stim.include?(stair) && # check if min seen
            line[2][0].to_i == correct_button.to_i && stim.to_i == min_stim[stair].to_i
          seen_min[stair] += 1
        end

        if line[1] == 'button_press' && # max_stim.include?(stair) && # check if max !seen
            line[2][0].to_i != correct_button.to_i && stim.to_i == max_stim[stair].to_i
          not_seen_max[stair] += 1
        end

        if line[1] == 'response_window_timeout' && stim == max_stim[stair].to_i # check if max !seen for 1 button case # max_stim.include?(stair) &&
          not_seen_max[stair] += 1
        end

      end

      reversal_count.each_with_index do |value, i|
        out << "Staircase: #{i + 1}\n"
        out << "\tNot seen max: #{not_seen_max[i]}\n"
        out << "\tSeen min: #{seen_min[i]}\n"

        for j in 0...value
          out << "\tReversal #{j + 1} : #{reversal_value[i][j]}\n"
        end
      end

    else
      # record (in)correct for each stim level
      correct_count = {}
      incorrect_count = {}
      out << "MOCS\n"

      stim = 0
      correct_button = 0

      lines.each do |line|

        if line[1] == 'presented_image'
          # record the current stim value
          temp = line[2].split('/')
          stim = temp[0].to_i
          correct_button = temp[1][0].to_i
          unless correct_count.has_key?(stim)
            correct_count[stim] = 0
          end
          unless incorrect_count.has_key?(stim)
            incorrect_count[stim] = 0
          end
        end

        if line[1] == 'button_press'
          # count correct or incorrect
          if questions_per_folder == '1:1'
            out << "Pressed #{line[2]}%s\n" # if only one question, just print button
          else
            if correct_button == line[2][0].to_i
              correct_count[stim] += 1
            else
              incorrect_count[stim] += 1
            end
          end
        end
        if line[1] == 'response_window_timeout' && num_buttons == 1 # incorrect for 1 button case
          incorrect_count[stim] += 1
        end
      end

      if questions_per_folder != '1:1'
        # don't print table if only one question
        out << "Level Correct Incorrect Correct(%%)\n"
        correct_count.keys.sort.each do |i| # put in numeric order of level (key in correct_count[])
          if correct_count[i] + incorrect_count[i] > 0
            out << sprintf("%5d %6d %8d %8.1f%%\n", i, correct_count[i], incorrect_count[i], correct_count[i] / (correct_count[i] + incorrect_count[i]).to_f * 100)
          else
            out << sprintf("%5d %6d %8d ???\n", i, correct_count[i], incorrect_count[i])
          end
        end
      end
    end

    out << "Start time: #{Time.at(start_time).strftime('%e/%m/%Y %H:%M:%S')}\n"
    out << "End time  : #{Time.at(end_time).strftime('%e/%m/%Y %H:%M:%S')}\n"
    d = end_time - start_time
    m = (d / 60.0).floor
    if d >= 0
      out << "Duration  : #{m} minutes #{d - 60 * m} seconds\n"
    end

    return out
  end

end
