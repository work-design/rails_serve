module TheRole::Routes
  extend self

  def routes_wrapper
    ary = []

    routes.each do |route|
      ary << detail(route)
    end

    ary
  end

  def actions(controller)
    routes_wrapper.select { |i| i[:controller] == controller.to_s }.map { |i| i[:action] }.uniq
  end

  private
  def detail(route)
    wrap = ActionDispatch::Routing::RouteWrapper.new(route)
    info = route.defaults

    {
      verb: route.verb,
      path: wrap.path,
      controller: info[:controller],
      action: info[:action]
    }
  end

  def routes
    @routes ||= Rails.application.routes.routes
  end

end