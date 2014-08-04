ENV['RACK_ENV'] = 'test'

require_relative '../lib/gameon-points.rb'  
require_relative '../sample/web.rb'  
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'

class MiniTest::Spec
  #include Rack::Test::Methods

  #def app
    #Rack::Builder.parse_file(File.dirname(__FILE__) + '/../config.ru').first
  #end
end
