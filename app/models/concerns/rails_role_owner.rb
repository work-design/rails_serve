module RailsRoleOwner

  def permit_with(rails_role_user, options = {})
    refs = reflections.select { |_, v|
      !v.through_reflection? && rails_role_user.class.name == v.class_name
    }
    refs = reflections.select { |_, v| !v.through_reflection? && rails_role_user.class.base_class.name == v.class_name } if refs.blank?

    scope = {}
    refs.each do |_, ref|
      scope[ref.foreign_key] = rails_role_user.allow_ids
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

ActiveRecord::Base.extend RailsRoleOwner
