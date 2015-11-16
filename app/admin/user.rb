ActiveAdmin.register User do

  permit_params do
    params = [:email, :password, :password_confirmation, :affiliation, :hook_url, :default_participant_id]
    params << :role if current_user.admin?
    params
  end

  index do
    selectable_column
    id_column
    column :email
    column :affiliation
    column :hook_url
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :affiliation
      f.input :hook_url
      f.input :default_participant, collection: current_user.participants
      f.input :role, as: :select, collection: [['Admin', 'admin']] if current_user.admin?
    end
    f.actions
  end

  show do |user|

    panel 'User Details' do
      attributes_table_for user do
        row :email
        row :affiliation
        row :hook_url
        row :default_participant
      end
    end

    panel 'User Tracking' do
      attributes_table_for user do
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :created_at
        row :updated_at
      end
    end

  end

  controller do

    def update
      if params[:user][:password].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end
      super
    end

  end

end
