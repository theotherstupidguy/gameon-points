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
    include GameOn::Middleware 
    #def initialize(app, opts= GameOn::Points::Opts, params= GameOn::Points::Params)
    def initialize(app, opts={},params={})
      @app = app
      @opts = opts 
      @params = params
    end
    def call(env)
      if !@params.nil? && @params.has_key?(:add)
	env[:gameon].add_points(@params[:add] * @opts[:inc_by]) 
	#env[:gameon].points = GameOn::Env.add_points(@params[:add] * @opts[:inc_by]) 
	#GameOn::Env.add_points(@params[:add] * @opts[:inc_by]) 
      end
      if !@params.nil? && @params.has_key?(:remove) 
	env[:gameon].remove_points(@params[:remove] * @opts[:dec_by]) 
      end
      @app.call(env) # run the next middleware
    end
  end
end
