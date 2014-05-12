Gem::Specification.new do |spec|
  spec.name          = "gameon-points"
  spec.version       = "0.0.0.pre1" 
  spec.authors       = ["theotherstupidguy"]
  spec.email         = ["theotherstupidguy@gmail.com"]
  spec.summary       = "simple points system for gameon" 
  spec.description   = "" 
  spec.homepage      = "https://github.com/gameon-rb/gameon-points"
  spec.license       = "MIT"

  spec.files         = ["lib/gameon-points.rb"]

  spec.add_development_dependency "gameon", "0.0.0.pre1"
  spec.add_development_dependency "gameon-redis", "0.0.0.pre1"
end
