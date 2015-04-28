ActiveAdmin.register Participant do

  permit_params do
    permitted = [:username, :enabled]
    permitted << :user_id if current_user.admin?
    permitted
  end

  actions :all, except: [:show]

  controller do

    def new
      @participant = Participant.new
      @participant.user = current_user
      new!
    end

  end

  scope_to :current_user, unless: proc{ current_user.admin? }

  index do
    selectable_column
    id_column
    column 'Admin User', :user if current_user.admin?
    column :username
    column :enabled
    column :configurations do |participant|
      count = participant.participant_configurations.count
      link_to '%d Configuration'.pluralize(count) % count, admin_participant_participant_configurations_path(participant)
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

  form do |f|

    f.inputs do

      f.input :user if current_user.admin?
      f.input :username
      f.input :enabled

      config_count = participant.participant_configurations.count
      f.input 'Configurations', as: :output, html: link_to('%d Configuration'.pluralize(config_count) % config_count, admin_participant_participant_configurations_path(participant))

      log_count = participant.logs.count
      f.input 'Logs', as: :output, html: link_to('%d Log'.pluralize(log_count) % log_count, admin_participant_logs_path(participant))

    end

    f.inputs 'Timestamps' do

      f.input :created_at, as: :output
      f.input :updated_at, as: :output

    end

    f.actions

  end

end
