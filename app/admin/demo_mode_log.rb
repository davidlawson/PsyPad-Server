ActiveAdmin.register Log, as: 'DemoModeLog' do

  permit_params :test_date, :content

  actions :all, except: [:new, :edit]

  controller do
    def scoped_collection
      collection = end_of_association_chain
      collection = collection.where(participant: nil)
      collection = collection.where(user: current_user) unless current_user.admin?
      collection
    end
  end

  index do
    selectable_column
    id_column
    column :user if current_user.admin?
    column :configuration_name
    column :test_date
    column 'Log upload date', :created_at
    actions
  end

  filter :test_date
  filter :created_at, label: 'Log upload date'
  filter :content

  show do |log|
    panel 'Log Details' do
      attributes_table_for log do
        row :test_date
        row 'Log upload date' do
          log.created_at
        end
      end
    end

    panel 'Log Analysis' do
      pre log.text_analysis, class: 'log-content'
    end

    panel 'Log Content' do
      pre log.content, class: 'log-content'
    end
  end

end
