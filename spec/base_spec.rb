require_relative './spec_helper'

describe "a Ruby Application 'GoMaster' that applies DDD 2.0" do
  before do
    @user_id = "07"
    redis = Redis.new
    redis.del @user_id + 'gameon' 
  end
  it 'is a GameOn Middleware' do
    skip
    GameOn::Points.include?(GameOn::Middleware).must_equal true
  end

  it 'adds points using {:add => 2}' do 
    module GoMaster 
      module Gamebook 
	extend GameOn::DSL
	points = {:inc_by => 1, :dec_by => 1 }

	context :good_mayor do 
	  statment [:user, :visits, :good_page_one] do 
	    activation GameOn::Points, points, {:add => 2}
	  end
	end
      end
    end
    @gameon = GameOn::Env.set @user_id do 
      on :good_mayor do 
	activity [:user, :visits, :good_page_one]
      end
    end
    @gameon.points.must_equal 2 
  end

  it 'gets a GameOn activity' do 
    skip
    @app_key = "secret_key used by domain frameworks for encryptions"
    @gameon = GameOn::Env.get @user_id 
    @gameon.id.must_equal @user_id + "gameon"
  end

  describe "GameOn's Gamebook" do
    it 'extends GameOn::DSL' do
      GoMaster::Gamebook.singleton_class.include?(GameOn::DSL).must_equal true
    end
  end
end
