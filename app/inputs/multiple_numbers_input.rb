class MultipleNumbersInput
  include Formtastic::Inputs::Base
  include Formtastic::Inputs::Base::Numeric
  include Formtastic::Inputs::Base::Placeholder

  def to_html

    fields = ''.html_safe
    for text, field in options[:fields]
      options = input_html_options
      options[:id] = field
      fields << text.html_safe << builder.number_field(field, options)
    end

    input_wrapping do
      label_html <<
      fields
    end

  end

  def step_option
    super || "any"
  end

  def error_keys
    options[:fields].flatten.compact.uniq
  end

end