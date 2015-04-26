ActiveAdmin.register Log, as: 'DemoModeLog' do

  permit_params :test_date, :content

  controller do
    def scoped_collection
      collection = end_of_association_chain
      collection.where(user: current_user, participant: nil)
    end
  end

  before_create do |log|
    log.user = current_user
  end

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
      @demo_mode_log = Log.new
      @demo_mode_log.test_date = Time.current
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