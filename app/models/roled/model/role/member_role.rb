module Roled
  module Model::Role::MemberRole


    def delete_cache
      if Rails.cache.delete('member_role_hash')
        logger.debug "\e[35m  delete cache member role hash \e[0m"
      end
    end

  end
end
