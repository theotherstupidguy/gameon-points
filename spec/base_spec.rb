require_relative './spec_helper'

describe "a Ruby Application 'GoMaster' that applies DDD 2.0" do
  before do
    @user_id = "02"

    GameOn::Points::Params[:addition] = {:add => 5}  

    module GoMaster 
      module Gamebook 
	extend GameOn::DSL
	points = {:inc_by => 1, :dec_by => 1 }

	context :good_mayor do 
	  statment [:user, :visits, :good_page_one] do 
	    #activation GameOn::Points, points, {:add => 1}  
	    activation GameOn::Points, points, GameOn::Points::Params[:addition] 
	  end
	  statment [:user, :visits, :good_page_two] do 
	    activation GameOn::Points, points, GameOn::Points::Params[:addition] 
	  end

	  statment [:user, :visits, :good_page_three] do 
	    activation GameOn::Points, points,{:add => 1000}  
	  end
	end

	context :bad_mayor do 
	  statment [:user, :visits, :bad_page_one] do 
	    activation GameOn::Points, points ,{:remove => 1}  
	  end
	  statment [:user, :visits, :bad_page_two] do 
	    activation GameOn::Points, points ,{:remove => 1}  
	  end
	  statment [:user, :visits, :bad_page_three] do 
	    activation GameOn::Points, points ,{:remove => 1}  
	  end
	end
      end
    end
  end

  describe GameOn::Points do
    it 'is a GameOn Middleware' do
      GameOn::Points.include?(GameOn::Middleware).must_equal true
    end
    it 'mocks the gameon framework' do
      #skip
    end
  end

  it 'sets a GameOn activity' do 
    @gameon = GameOn::Env.set @user_id do 
      on :good_mayor do 
	activity [:user, :visits, :good_page]
      end
    end
    @gameon.points.must_equal 5 
  end

  it 'gets a GameOn activity' do 
    @app_key = "secret_key used by domain frameworks for encryptions"
    @gameon = GameOn::Env.get @user_id 
    @gameon.id.must_equal @user_id + "gameon"
  end

  describe "GameOn's Gamebook" do
    it 'extends GameOn::DSL' do
      GoMaster::Gamebook.singleton_class.include?(GameOn::DSL).must_equal true
    end
    it ''do
    end
  end
end
