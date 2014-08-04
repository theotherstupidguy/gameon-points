require 'sinatra'

class User
  attr_accessor :id
  def initialize id
    @id = id
  end
end

get '/good/:id' do
  GameOn::Points::Params[:addition] = {:add => 1}  

  module GoMaster 
    module Gamebook 
      extend GameOn::DSL
      opts = {:inc_by => 1, :dec_by => 1 }

      context :good_mayor do 
	statment [:user, :visits, :good_page_four] do 
	  activation GameOn::Points, opts, GameOn::Points::Params[:addition] 
	end
      end
    end
  end

  user = User.new params[:id]


  GameOn::Env.set user.id do 
    on :good_mayor do 
      activity [:user, :visits, :good_page_four]
    end
  end

  gameon = GameOn::Env.get user.id 

  "#{gameon.id}: #{gameon.points}"  #"#{Time.now} Welcome #{gameon.id} Current score is #{gameon.points}"
end
