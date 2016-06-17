require 'zip'
require 'tempfile'

ActiveAdmin.register ImageSet do

  permit_params :name, :user_id

  actions :all, except: [:new, :show]

  controller do
    def scoped_collection
      collection = end_of_association_chain
      collection = collection.where(user: [User.first, current_user].uniq) unless current_user.admin?
      collection
    end
  end

  scope :all, default: true
  scope :public_image_sets
  scope :private_image_sets

  before_create do |image_set|
    image_set.user = current_user
  end

  filter :user, collection: proc { current_user.admin? ? User.all : [User.first, current_user].uniq }
  filter :name
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column 'Owner', :user
    column :name
    column 'Preview' do |image_set|
      image_frame = image_set.image_groups.first.images.first.image_frames.first rescue nil
      if image_frame
        image_tag image_frame.thumbnail_data_uri, class: 'frame-preview'
      else
        em 'No preview'
      end
    end
    column :image_groups do |image_set|
      count = image_set.image_groups.count
      link_to '%d Image Group'.pluralize(count) % count, admin_image_set_image_groups_path(image_set)
    end
    column :created_at
    column :updated_at
    actions defaults: true do |image_set|
      link_to 'Download', download_admin_image_set_path(image_set)
    end
  end

  form do |f|

    f.inputs 'Details' do

      f.input :user if current_user.admin?
      f.input :name

      count = image_set.image_groups.count
      f.input 'Image Groups', as: :output, html: link_to('%d Image Group'.pluralize(count) % count, admin_image_set_image_groups_path(image_set))

      image_frame = image_set.image_groups.first.images.first.image_frames.first rescue nil
      if image_frame
        f.input 'Preview', as: :output, html: image_tag(image_frame.thumbnail_data_uri, class: 'frame-preview')
      end

    end

    f.inputs 'Timestamps' do

      f.input :created_at, as: :output
      f.input :updated_at, as: :output

    end

    f.actions

  end

  member_action :download, method: [:get] do

    archive_name = 'archive.zip'
    archive_path = File.join(resource.directory, archive_name)

    FileUtils.rm archive_path, force: true
    success = system "cd #{resource.directory}; zip -r -q #{archive_path} ./ -x #{archive_name}"

    if success
      # TODO this isn't streaming (I think)
      send_file archive_path, stream: true
    else
      redirect_to admin_image_sets_path, notice: 'Failed to download image set'
    end

  end

  action_item :download, only: :show do
    link_to 'Download Image Set', action: :download
  end

  action_item :import, only: :index do
    link_to 'Import Image Set', action: :import
  end

  collection_action :import, method: [:get, :post] do
    unless request.post?
      render 'admin/image_set/import'
      return
    end

    unless params[:import] && params[:import][:archive]
      redirect_to import_admin_image_sets_path, notice: 'No file selected'
      return
    end

    unless params[:import][:name]
      redirect_to import_admin_image_sets_path, notice: 'No name entered'
      return
    end

    file = params[:import][:archive]
    name = params[:import][:name]

    # if file.is_a?(StringIO)
    #   temp_file = Tempfile.new('import')
    #   temp_file.binmode
    #
    #   temp_file.write file.read
    #   file = temp_file
    #   temp_file.close
    # end

    unless file.respond_to?(:path)
      redirect_to import_admin_image_sets_path, notice: 'Could not upload file, please try again'
      return
    end

    dir = Rails.application.config.image_set_directory + SecureRandom.urlsafe_base64
    FileUtils.mkdir_p dir
    success = system "unzip -q -o #{file.path} -d #{dir}"
    file.close(true)

    unless success
      FileUtils.rm_rf dir
      redirect_to import_admin_image_sets_path, notice: 'Failed to unzip archive'
      return
    end

    image_set = ImageSet.create(name: name, user: current_user, directory: dir)

    warnings = []
    imported = []

    groups = {}
    animated_images = {}

    ActiveRecord::Base.logger.silence do

      ActiveRecord::Base.transaction do

        Dir["#{dir}/**/*"].each do |filename|

          unless filename.end_with?('.png') || filename.ends_with?('.wav')
            warnings << 'Ignored file (not a .png or .wav): ' + filename unless File.directory?(filename)
            next
          end

          components = filename.sub(/^#{Regexp.escape(dir)}?#{Regexp.escape(File::SEPARATOR)}/, '').split(File::SEPARATOR)

          if components.count == 1

            allowed = [
              'background.png', 
              'title.png', 
              'correct.wav', 
              'incorrect.wav', 
              'on.wav', 
              'off.wav', 
              'timeout.wav', 
              'button1.png',
              'button2.png',
              'button3.png',
              'button4.png',
              'secondaryButton1.png',
              'secondaryButton2.png',
              'secondaryButton3.png',
              'secondaryButton4.png',
              'secondaryImage1.png',
              'secondaryImage2.png',
              'secondaryImage3.png',
              'secondaryImage4.png'
            ]

            unless allowed.include?(components[0])
              warnings << 'Unexpected file in root of archive: "' + components[0] + '", only accepts ' + allowed.join(', ') + '.'
              next
            end

            case components[0]

              when 'background.png'
                image_set.background_image_path = filename
                image_set.background_image_size = File.size(filename)

              when 'title.png'
                image_set.title_image_path = filename
                image_set.title_image_size = File.size(filename)

              when 'correct.wav'
                image_set.correct_wav_path = filename
                image_set.correct_wav_size = File.size(filename)

              when 'incorrect.wav'  
                image_set.incorrect_wav_path = filename
                image_set.incorrect_wav_size = File.size(filename)

              when 'on.wav'  
                image_set.on_wav_path = filename
                image_set.on_wav_size = File.size(filename)

              when 'off.wav'  
                image_set.off_wav_path = filename
                image_set.off_wav_size = File.size(filename)

              when 'timeout.wav'  
                image_set.timeout_wav_path = filename
                image_set.timeout_wav_size = File.size(filename)

              when 'button1.png'
                image_set.button1_image_path = filename
                image_set.button1_image_size = File.size(filename)

              when 'button2.png'
                image_set.button2_image_path = filename
                image_set.button2_image_size = File.size(filename)

              when 'button3.png'
                image_set.button3_image_path = filename
                image_set.button3_image_size = File.size(filename)

              when 'button4.png'
                image_set.button4_image_path = filename
                image_set.button4_image_size = File.size(filename)

              when 'secondaryButton1.png'
                image_set.secondary_button1_image_path = filename
                image_set.secondary_button1_image_size = File.size(filename)

              when 'secondaryButton2.png'
                image_set.secondary_button2_image_path = filename
                image_set.secondary_button2_image_size = File.size(filename)

              when 'secondaryButton3.png'
                image_set.secondary_button3_image_path = filename
                image_set.secondary_button3_image_size = File.size(filename)

              when 'secondaryButton4.png'
                image_set.secondary_button4_image_path = filename
                image_set.secondary_button4_image_size = File.size(filename)

              when 'secondaryImage1.png'
                image_set.secondary_image1_path = filename
                image_set.secondary_image1_size = File.size(filename)

              when 'secondaryImage2.png'
                image_set.secondary_image2_path = filename
                image_set.secondary_image2_size = File.size(filename)

              when 'secondaryImage3.png'
                image_set.secondary_image3_path = filename
                image_set.secondary_image3_size = File.size(filename)

              when 'secondaryImage4.png'
                image_set.secondary_image4_path = filename
                image_set.secondary_image4_size = File.size(filename)
            end

            image_set.save

            imported << { name: components.join('/'), size: File.size(filename) }

          elsif components.count == 2

            group = groups[components[0]] || ImageGroup.create(image_set: image_set, name: components[0])
            groups[components[0]] = group

            image = Image.create(name: components[1], animated: false, image_group: group)

            image_frame = ImageFrame.create(frame_path: filename, frame_size: File.size(filename), image: image)

            imported << { name: components.join('/'), size: image_frame.frame_size }

          elsif components.count == 3

            group = groups[components[0]] || ImageGroup.create(image_set: image_set, name: components[0])
            groups[components[0]] = group

            animated_images[components[0]] = {} unless animated_images.has_key?(components[0])

            image = animated_images[components[0]][components[1]] || Image.create(image_group: group, name: components[1], animated: true)
            animated_images[components[0]][components[1]] = image

            image_frame = ImageFrame.create(frame_path: filename, frame_size: File.size(filename), image: image)

            imported << { name: components.join('/'), size: image_frame.frame_size }

          else

            warnings << 'Ignored file (invalid directory structure): ' + filename

          end
        end

        if imported.count == 0
          image_set.destroy
          warnings.unshift "Nothing valid was imported, not creating an image set on the server.\n"
        end

        render 'admin/image_set/imported', locals: { warnings: warnings, imported: imported, image_set: image_set }

      end

    end

  end

end
