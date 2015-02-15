class ColonCommaSeparatedValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    unless value =~ /^([0-9]+:[0-9]+,)*([0-9]+:[0-9]+)$/
      object.errors[attribute] << (options[:message] || 'must be of the format &lt;level&gt;:&lt;count&gt;,&lt;level&gt;:&lt;count&gt;...')
    end
  end

end