module RoleTranslateHelper

  def the_role_t(section, rule = nil)

    if rule
      key = "#{section}.#{rule}"
      unless I18n.exists?(key)
        key = "action.#{rule}"
      end

      if I18n.exists?(key)
        return I18n.t(key)
      else
        return rule
      end
    else
      key = "controller.#{section}"

      if I18n.exists?(key)
        return I18n.t(key)
      else
        return section
      end
    end
  end

end