ActiveAdmin.register Participant do

  permit_params do
    permitted = [:username, :enabled]
    permitted << :user_id if current_user.admin?
    permitted
  end

  before_create do |participant|
    participant.user = current_user
  end

  scope_to :current_user, unless: proc{ current_user.admin? }

  index do
    selectable_column
    id_column
    column 'Admin User', :user if current_user.admin?
    column :username
    column :enabled
    column :configurations do |participant|
      count = participant.configurations.count
      link_to '%d Configuration'.pluralize(count) % count, admin_participant_configurations_path(participant)
    end
    column :logs do |participant|
      count = participant.logs.count
      link_to '%d Log'.pluralize(count) % count, admin_participant_logs_path(participant)
    end
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
        if current_user.admin?
          row 'Admin User' do
            participant.user
          end
        end
        row :username
        bool_row :enabled
      end
    end

    panel 'Configurations' do
      if participant.configurations.count > 0
        table_for participant.configurations do
          column :name do |configuration|
            link_to configuration.name, admin_participant_configuration_path(participant, configuration)
          end
          column :enabled
          column :is_practice
        end
      end

      span do
        link_to 'Add Configuration', new_admin_participant_configuration_path(participant), class: 'button'
      end

      span do
        link_to 'View Configurations', admin_participant_configurations_path(participant), class: 'button'
      end
    end

    panel 'Logs' do
      if participant.logs.count > 0
        table_for participant.logs do
          column 'ID' do |log|
            link_to log.id, resource_path(log)
          end
          column :test_date
          column :log_upload_date do |log|
            log.created_at
          end
          column do |log|
            link_to 'View Log', admin_participant_log_path(participant, log)
          end
        end
      end

      span do
        link_to 'View Logs', admin_participant_logs_path(participant), class: 'button'
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

  form do |f|

    f.inputs do

      f.input :user if current_user.admin?
      f.input :username
      f.input :enabled

    end

    f.actions

  end

end
