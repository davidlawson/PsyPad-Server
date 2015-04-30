class OutputInput
  include Formtastic::Inputs::Base

  def to_html

    content = options.has_key?(:html) ? options[:html] : template.pretty_format(object[method])
    content = '<em class="not-set">[not set]</em>'.html_safe if content.nil? || content.length == 0

    input_wrapping do
      label_html <<
      content
    end

  end

end
