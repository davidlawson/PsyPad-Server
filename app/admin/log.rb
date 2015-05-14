ActiveAdmin.register Log do

  belongs_to :participant

  navigation_menu :default
  menu false

  actions :all, except: [:new, :edit]

  permit_params :test_date, :content

  index do
    selectable_column
    id_column
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
        row :participant
        row :test_date
        row 'Log upload date' do
          log.created_at
        end
      end
    end

    panel 'Log Content' do
        pre log.content, class: 'log-content'
    end
  end

end
