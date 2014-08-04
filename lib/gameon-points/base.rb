GameOn::Env.register do
  attr_accessor :points

  def add_points value
    (@points.nil?) ? (@points = value) : (@points += value) 
  end

  def remove_points value
    (@points.nil?) ? (@points = -value) : (@points -= value) 
  end
end

module GameOn
  class Points  
    include GameOn::Middleware 

    def initialize(app, opts={},params={})
      @app = app
      @opts = opts 
      @params = params
    end

    def call(env)
      if !@opts.nil? && !@params.nil? && @params.has_key?(:add)
	env[:gameon].add_points(@params[:add] * @opts[:inc_by]) 
	#env[:gameon].points = GameOn::Env.add_points(@params[:add] * @opts[:inc_by]) 
	#GameOn::Env.add_points(@params[:add] * @opts[:inc_by]) 
      end
      if !@opts.nil? && !@params.nil? && @params.has_key?(:remove) 
	env[:gameon].remove_points(@params[:remove] * @opts[:dec_by]) 
      end
      @app.call(env) # run the next middleware
    end
  end
end
