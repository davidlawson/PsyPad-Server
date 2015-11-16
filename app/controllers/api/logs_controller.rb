class API::LogsController < API::BaseController

  skip_before_filter :verify_authenticity_token

  respond_to :json

  def upload

    logs = params[:logs]

    logs.each do |log_data|

      timestamp = Time.at(log_data[:timestamp]).to_datetime

      next if current_user.logs.where(test_date: timestamp).count > 0

      content = log_data[:content]

      log = Log.new
      log.content = content
      log.test_date = timestamp
      log.user = current_user

      if log_data.has_key?(:participant)

        participant = current_user.participants.find_by_username!(log_data[:participant])
        log.participant = participant

      end

      log.save

      unless current_user.hook_url.nil?
        log.delay.send_to_external_server(current_user.hook_url)
      end

    end

    render json: { success: true }, status: 200

  end

end
