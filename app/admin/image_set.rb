require 'zip'
require 'tempfile'

ActiveAdmin.register ImageSet do

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

  permit_params :name, image_groups_attributes: [ :id, :name, :_destroy ]

  scope_to :current_user, unless: proc{ current_user.admin? }

  filter :user, if: proc{ current_user.admin? }
  filter :name
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column 'Admin User', :user if current_user.admin?
    column :name
    column :image_groups do |image_set|
      count = image_set.image_groups.count
      link_to '%d Image Group'.pluralize(count) % count, admin_image_set_image_groups_path(image_set)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do |image_set|
    panel 'Image Set Details' do
      attributes_table_for image_set do
        if current_user.admin?
          row 'Admin User' do
            image_set.user
          end
        end
        row :name
        row :created_at
        row :updated_at
      end
    end

    panel 'Image Groups' do
      table_for image_set.image_groups do
        column :name do |image_group|
          link_to image_group.name, admin_image_set_image_group_path(image_set, image_group)
        end
        column :created_at
        column :updated_at
      end

      span do
        link_to 'Add Image Group', new_admin_image_set_image_group_path(image_set), class: 'button'
      end

      span do
        link_to 'View Image Groups', admin_image_set_image_groups_path(image_set), class: 'button'
      end
    end

    active_admin_comments
  end

  form do |f|

    f.inputs 'Details' do

      f.input :user if current_user.admin?
      f.input :name

    end

    # f.inputs 'Image Groups' do
    #
    #   f.has_many :image_groups, heading: false, allow_destroy: true do |a|
    #     a.input :name
    #   end
    #
    # end

    f.actions

  end

  action_item :import, only: :index do
    link_to 'Import Image Set', action: :import
  end

  collection_action :import, method: [:get, :post] do
    if request.post?

      unless params[:import] && params[:import][:archive]
        redirect_to import_admin_image_sets_path, notice: 'No file selected'
        return
      end

      file = params[:import][:archive]

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

      ActiveRecord::Base.logger.silence do

        ActiveRecord::Base.transaction do

          image_set = ImageSet.create(name: file.original_filename, user: current_user)

          warnings = []
          imported = []

          groups = {}
          animated_images = {}

          begin

            dir = "/tmp/#{SecureRandom.urlsafe_base64}"
            FileUtils.mkdir_p dir
            success = system "unzip -q -o #{file.path} -d #{dir}"
            file.close(true)

            unless success
              FileUtils.rm_rf dir
              throw 'Failed to unzip archive'
            end

            Dir["#{dir}/**/*"].each do |filename|

              unless filename.end_with?('.png')
                warnings << 'Ignored file (not a .png): ' + filename unless File.directory?(filename)
                next
              end

              components = filename.split('/').drop(3)

              if components.count == 1

                if components[0] != 'background.png'
                  warnings << 'Unexpected image in root of archive, only accepts "background.png"'
                  next
                end

                image_set.background_image_path = filename
                image_set.background_image_size = File.size(filename)
                image_set.save

                imported << { name: components.join('/'), size: image_set.background_image_size }

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

            render 'admin/image_set/imported', locals: { warnings: warnings, imported: imported, image_set: image_set }

          rescue => e
            redirect_to import_admin_image_sets_path, notice: 'Could not import images: ' + e.to_s
          end

        end

      end

    else
      render 'admin/image_set/import'
    end
  end

end
