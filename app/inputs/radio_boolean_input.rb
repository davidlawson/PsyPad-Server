class RadioBooleanInput < Formtastic::Inputs::RadioInput

  def initialize(*args)
    collection = [['Yes', '1'], ['No', '0']]
    super
  end

end