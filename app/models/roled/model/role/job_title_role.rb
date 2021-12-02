module Roled
  module Model::Role::JobTitleRole


    def delete_cache
      if Rails.cache.delete('job_title_role_hash')
        logger.debug "\e[35m  delete cache job title role hash \e[0m"
      end
    end

  end
end
