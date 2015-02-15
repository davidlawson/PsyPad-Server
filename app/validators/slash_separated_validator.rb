class SlashSeparatedValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    if object[options[:count]]
      unless value =~ /^([0-9]+\/){#{object[options[:count]] - 1}}[0-9]+$/
        object.errors[attribute] << (options[:message] || "must be #{object[options[:count]]} integers separated by forward slashes")
      end
    else
      unless value =~ /^([0-9]+\/)*[0-9]+$/
        object.errors[attribute] << (options[:message] || 'must be integers separated by forward slashes')
      end
    end
  end

end