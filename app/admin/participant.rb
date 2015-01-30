ActiveAdmin.register Participant do

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

  permit_params :user_id, :username, :enabled

  permit_params do
    permitted = [:username, :enabled]
    permitted << :user_id if current_user.admin?
    permitted
  end

  scope_to :current_user, unless: proc{ current_user.admin? }

  index do
    selectable_column
    column 'Admin User', :user if current_user.admin?
    column :username
    column :enabled
    column :created_at
    column :updated_at
    actions
  end

  filter :user, if: proc{ current_user.admin? }
  filter :username
  filter :enabled
  filter :created_at
  filter :updated_at

  show do |participant|
    panel 'Participant Details' do
      attributes_table_for participant do
        row :id
        if current_user.admin?
          row 'Admin User' do
            participant.user
          end
        end
        row :username
        row :enabled
      end
    end

    panel 'Timestamps' do
      attributes_table_for participant do
        row :created_at
        row :updated_at
      end
    end

    active_admin_comments
  end

  sidebar 'Configurations', only: [:show, :edit] do
    link_to 'View Configurations', admin_participant_configurations_path(participant), class: 'button'
  end

  controller do

    def new
      @participant = Participant.new
      @participant.user = current_user
      new!
    end

  end

  form do |f|

    f.inputs do

      f.input :user if current_user.admin?
      f.input :username
      f.input :enabled

    end

    f.actions

  end

end
