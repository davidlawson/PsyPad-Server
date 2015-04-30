class SlashCommaSeparatedValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    
    expected_groups = object[options[:slash]]
    expected_values = object[options[:comma]].split('/').map(&:to_i)

    if expected_groups != expected_values.count
      object.errors[attribute] << (options[:message] || "can't be valid with the other values as they are")
      return
    end

    groups = value.split('/')
    
    if expected_groups != groups.count
      object.errors[attribute] << (options[:message] || "must contain #{expected_groups} groups separated by forward slashes")
      return
    end
    
    values = groups.map { |v| v.split(',').count }

    if values != expected_values
      object.errors[attribute] << (options[:message] || "has incorrect numbers of comma-separated integers inside at least one group")
      return
    end

  end

end
