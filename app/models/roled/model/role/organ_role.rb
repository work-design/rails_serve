module Roled
  module Model::Role::OrganRole


    def delete_cache
      if Rails.cache.delete('organ_role_hash')
        logger.debug "\e[35m  delete cache organ role hash \e[0m"
      end
    end

  end
end
