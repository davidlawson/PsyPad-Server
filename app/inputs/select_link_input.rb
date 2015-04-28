class SelectLinkInput < Formtastic::Inputs::SelectInput

  def select_html
    super + link
  end

  def link
    template.link_to options[:link_text], options[:link_url], class: 'button', target: '_blank'
  end

  def as
    'select'
  end

end