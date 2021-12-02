module Roled
  module Model::Role::UserRole


    def delete_cache
      if Rails.cache.delete('user_role_hash')
        logger.debug "\e[35m  delete cache user role hash \e[0m"
      end
    end

  end
end
