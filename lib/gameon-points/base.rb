GameOn::Env.register do
  attr_accessor :points
  def add_points value
    if !@points.nil?
      @points = @points + value
    else 
      @points = 0
    end
  end
  def remove_points value
    if !@points.nil?
      @points = @points - value
    else 
      @points = 0
    end
  end
end

module GameOn
  class Points
    def initialize(app, opts={},params={})
      @app = app
      @params = params
    end
    def call(env)
      if @params.has_key?(:add) 
	env[:gameon].add_points @params[:add] 
      end
      if @params.has_key?(:remove) 
	env[:gameon].remove_points @params[:remove] 
      end
      @app.call(env) # run the next middleware
    end
  end
end
