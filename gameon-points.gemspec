# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "gameon-points"
  spec.version       = "0.0.0.pre17" 
  spec.authors       = ["theotherstupidguy"]
  spec.email         = ["theotherstupidguy@gmail.com"]
  spec.summary       = "simple points system for gameon" 
  spec.description   = "" 
  spec.homepage      = "https://github.com/gameon-rb/gameon-points"
  spec.license       = "MIT"

  spec.files         = Dir.glob("{lib}/**/*") 
  #spec.add_development_dependency "gameon" 
  #spec.add_development_dependency "gameon-redis"
end
