module Serve
  class My::ServingsController < My::BaseController
    before_action :set_item

    def index
      @servings = @item.servings
    end

    private
    def set_item
      @item = Trade::Item.find params[:item_id]
    end

  end
end
