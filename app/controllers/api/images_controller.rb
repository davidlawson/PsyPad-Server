class API::ImagesController < API::BaseController

  include ActionController::Live

  def export

    image_set = ImageSet.where(user: [current_user, User.first]).find(params[:id])

    filename = image_set.name + '.combined'

    response.headers['Content-Type'] = 'application/octet-stream'
    response.headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
    response.headers['Content-Transfer-Encoding'] = 'binary'

    if image_set.background_image_path.present?
      File.open(image_set.background_image_path, 'rb') do |file|
        while (chunk = file.read(16384))
          response.stream.write chunk
        end
      end
    end

    if image_set.title_image_path.present?
      File.open(image_set.title_image_path, 'rb') do |file|
        while (chunk = file.read(16384))
          response.stream.write chunk
        end
      end
    end

    if image_set.correct_wav_path.present?
      File.open(image_set.correct_wav_path, 'rb') do |file|
        while (chunk = file.read(16384))
          response.stream.write chunk
        end
      end
    end

    if image_set.incorrect_wav_path.present?
      File.open(image_set.incorrect_wav_path, 'rb') do |file|
        while (chunk = file.read(16384))
          response.stream.write chunk
        end
      end
    end

    if image_set.on_wav_path.present?
      File.open(image_set.on_wav_path, 'rb') do |file|
        while (chunk = file.read(16384))
          response.stream.write chunk
        end
      end
    end

    if image_set.off_wav_path.present?
      File.open(image_set.off_wav_path, 'rb') do |file|
        while (chunk = file.read(16384))
          response.stream.write chunk
        end
      end
    end

    if image_set.timeout_wav_path.present?
      File.open(image_set.timeout_wav_path, 'rb') do |file|
        while (chunk = file.read(16384))
          response.stream.write chunk
        end
      end
    end

    image_set.image_groups.order(name: :asc).each do |image_group|
      image_group.images.order(name: :asc).each do |image|
        image.image_frames.order(frame_name: :asc).each do |image_frame|
          File.open(image_frame.frame_path, 'rb') do |file|
            while (chunk = file.read(16384))
              response.stream.write chunk
            end
          end
        end
      end
    end

    response.stream.close

  end

end
