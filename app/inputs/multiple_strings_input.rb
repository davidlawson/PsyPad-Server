class MultipleStringsInput
  include Formtastic::Inputs::Base
  include Formtastic::Inputs::Base::Stringish
  include Formtastic::Inputs::Base::Placeholder

  def to_html

    fields = ''.html_safe
    for text, field in options[:fields]
      fields << text.html_safe << builder.text_field(field, input_html_options)
    end

    input_wrapping do
      label_html <<
      fields
    end
    
  end

  def error_keys
    options[:fields].flatten.compact.uniq
  end

end