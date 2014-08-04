require_relative './spec_helper'

describe "a Ruby Application 'GoMaster' that applies DDD 2.0" do
  before do
    @app_key = "secret_key used by domain frameworks for encryptions"
    @user_id = "07"
  end

  after do 
    redis = Redis.new
    redis.del @user_id + 'gameon' 
  end

  it 'is a GameOn Middleware' do
    GameOn::Points.include?(GameOn::Middleware).must_equal true
  end

  #describe "GameOn's Gamebook" do
  #  it 'extends GameOn::DSL' do
  #    GoMaster::Gamebook.singleton_class.include?(GameOn::DSL).must_equal true
  #  end
  #end

  it 'adds points using GameOn::Points::Params[:addition]' do 
    GameOn::Points::Params[:addition] = {:add => 2}  
    module GoMaster 
      module Gamebook 
	extend GameOn::DSL
	points = {:inc_by => 2, :dec_by => 1 }

	context :good_mayor do 
	  statment [:user, :visits, :good_page_one] do 
	    activation GameOn::Points, points, GameOn::Points::Params[:addition] 
	  end
	end
      end
    end
    @gameon = GameOn::Env.set @user_id do 
      on :good_mayor do 
	activity [:user, :visits, :good_page_one]
      end
    end
    @gameon.points.must_equal 2 * 2 
  end

  
  it 'adds points using {:add => 2}' do 
    module GoMaster 
      module Gamebook 
	extend GameOn::DSL
	points = {:inc_by => 1, :dec_by => 1 }

	context :good_mayor do 
	  statment [:user, :visits, :good_page_two] do 
	    activation GameOn::Points, points, {:add => 2}
	  end
	end
      end
    end

    @gameon = GameOn::Env.set @user_id do 
      on :good_mayor do 
	activity [:user, :visits, :good_page_two]
      end
    end

    @gameon.points.must_equal 2 
  end

  it 'removes points using GameOn::Points::Params[:subtraction]' do 
    GameOn::Points::Params[:subtraction] = {:remove => 2}  
    module GoMaster 
      module Gamebook 
	extend GameOn::DSL
	opts = {:inc_by => 1, :dec_by => 2 } #or GameOn::Points::Opts[:opt_1] =  {:inc_by => 2, :dec_by => 1 }

	context :bad_mayor do 
	  statment [:user, :visits, :bad_page_one] do 
	    activation GameOn::Points, opts, GameOn::Points::Params[:subtraction] 
	  end
	end
      end
    end
    @gameon = GameOn::Env.set @user_id do 
      on :bad_mayor do 
	activity [:user, :visits, :bad_page_one]
      end
    end
    @gameon.points.must_equal -2 * 2 
  end

  it 'removes points using {:subtraction => 2}' do 
    module GoMaster 
      module Gamebook 
	extend GameOn::DSL
	opts = {:inc_by => 1, :dec_by => 1} #or GameOn::Points::Opts[:opt_1] =  {:inc_by => 2, :dec_by => 1 }

	context :bad_mayor do 
	  statment [:user, :visits, :bad_page_two] do 
	    activation GameOn::Points, opts, {:remove => 2}
	  end
	end
      end
    end

    @gameon = GameOn::Env.set @user_id do 
      on :bad_mayor do 
	activity [:user, :visits, :bad_page_two]
      end
    end

    @gameon.points.must_equal -2 
  end

  it 'sets & gets a GameOn #id' do 
    GameOn::Env.set @user_id do 
      on :good_mayor do 
	activity [:user, :visits, :good_page_two]
      end
    end

    @gameon = GameOn::Env.get @user_id 
    @gameon.id.must_equal @user_id + "gameon"
  end
end
