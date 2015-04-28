class OutputInput
  include Formtastic::Inputs::Base

  def to_html

    input_wrapping do
      label_html <<
      (options.has_key?(:html) ? options[:html] : template.pretty_format(object[method]))
    end

  end

end