class API::ImagesController < API::BaseController

  include ActionController::Live

  def export

    image_set = current_user.image_sets.find(params[:id])

    filename = image_set.name + '.combined'

    response.headers['Content-Type'] = 'application/octet-stream'
    response.headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
    response.headers['Content-Transfer-Encoding'] = 'binary'

    image_set.image_groups.each do |image_group|
      image_group.images.each do |image|
        image.image_frames.each do |image_frame|
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