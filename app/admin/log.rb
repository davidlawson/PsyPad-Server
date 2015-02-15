ActiveAdmin.register Log do

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

  belongs_to :participant
  navigation_menu :default
  menu false

  permit_params :test_date, :content

  index do
    selectable_column
    id_column
    column :test_date
    column 'Log upload date', :created_at
    actions
  end

  filter :test_date
  filter :created_at, label: 'Log upload date'
  filter :content

  controller do

    def new
      @log = Log.new
      @log.test_date = Time.current
      new!
    end

  end

  form do |f|

    f.inputs do

      f.input :test_date
      f.input :content

    end

    f.actions

  end

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
        pre log.content
    end
  end

end
