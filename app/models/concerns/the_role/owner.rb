module TheRole::Owner

  def permit_with(the_role_user, options = {})
    refs = reflections.select { |_, v| v.class_name == the_role_user.class.name }

    scope = {}
    refs.each do |_, ref|
      scope[ref.foreign_key] = the_role_user.allow_ids
    end

    default_or(scope)
  end

  def default_or(hash)
    return all if hash.blank?

    keys = hash.keys
    query = where(keys[0] => hash[keys[0]])

    keys[1..-1].each do |key|
      query = query.or(where(key => hash[key]))
    end

    query
  end

end

ActiveRecord::Base.extend TheRole::Owner
