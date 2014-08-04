require_relative './spec_helper'

describe "a a generic Ruby Application 'GoMaster' that applies DDD 2.0" do
  before do
    @app_key = "secret_key used by domain frameworks for encryptions"
    @user_id = "07"
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
	opts = {:inc_by => 2, :dec_by => 1 }

	context :good_mayor do 
	  statment [:user, :visits, :good_page_one] do 
	    activation GameOn::Points, opts, GameOn::Points::Params[:addition] 
	  end
	end
      end
    end
    5.times do 
      @gameon = GameOn::Env.set @user_id do 
	on :good_mayor do 
	  activity [:user, :visits, :good_page_one]
	end
      end
    end
    @gameon.points.must_equal 2 * 2 * 5 
  end


  it 'adds points using {:add => 2}' do 
    module GoMaster 
      module Gamebook 
	extend GameOn::DSL
	opts = {:inc_by => 1, :dec_by => 1 }

	context :good_mayor do 
	  statment [:user, :visits, :good_page_two] do 
	    activation GameOn::Points, opts, {:add => 2}
	  end
	end
      end
    end
    5.times do 
      @gameon = GameOn::Env.set @user_id do 
	on :good_mayor do 
	  activity [:user, :visits, :good_page_two]
	end
      end
    end

    @gameon.points.must_equal 2 * 5 
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

  it 'removes points using {:remove => 2}' do 
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

  it 'adds & removes points using {add => 10} and {:remove => 2}' do 
    #skip
    module GoMaster 
      module Gamebook 
	extend GameOn::DSL
	opts = {:inc_by => 1, :dec_by => 1} #or GameOn::Points::Opts[:opt_1] =  {:inc_by => 2, :dec_by => 1 }

	context :good_mayor do 
	  statment [:user, :visits, :good_page_three] do 
	    activation GameOn::Points, opts, {:add => 10} 
	  end
	end

	context :bad_mayor do 
	  statment [:user, :visits, :bad_page_three] do 
	    activation GameOn::Points, opts, {:remove => 2}
	  end
	end
      end
    end

    #TODO only one context per set for now, must be fixed in the mushin gem
    GameOn::Env.set @user_id do 
      on :bad_mayor do 
	activity [:user, :visits, :bad_page_three]
      end
    end
    GameOn::Env.set @user_id do 
      on :good_mayor do 
	activity [:user, :visits, :good_page_three]
      end
    end

    @gameon = GameOn::Env.get @user_id 
    @gameon.points.must_equal 8 
  end

  it 'sets & gets a GameOn #id' do 
    GameOn::Env.set @user_id do 
      on :good_mayor do 
	activity [:user, :visits, :good_page_three]
      end
    end

    @gameon = GameOn::Env.get @user_id 
    @gameon.id.must_equal @user_id + "gameon"
  end

  after do 
    redis = Redis.new
    redis.del @user_id + 'gameon' 
  end

end

#
########################### Sinatra ############################
#

describe "a sinatra web application" do 
  before do
    @app_key = "secret_key used by domain frameworks for encryptions"
    @user_id = "01"
  end

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should successfully return the user's Points" do
    10.times do 
      get "/good/#{@user_id}"
    end
      last_response.must_be :ok?
      last_response.body.must_include "#{@user_id+'gameon'}:"
      last_response.body.must_equal "#{@user_id+'gameon'}: #{10}" 
  end

  after do 
    redis = Redis.new
    redis.del @user_id + 'gameon' 
  end

end
