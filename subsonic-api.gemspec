Gem::Specification.new do |s|
    s.name          = "subsonic-api"
    s.version       = "0.3"
    s.date          = "2011-07-20"
    s.platform      = Gem::Platform::RUBY
    s.summary       = "Subsonic music streaming api client"
    s.description   = "Interact with a subsonic music streaming server"

    s.authors  = ["Joseph Hsu", "James Hart"]
    s.email    = ["jhsu@josephhsu.com", "hjhart@gmail.com"]
    s.homepage = "http://github.com/hjhart/subsonic-api"

    s.require_paths = ["lib"]
    s.files = Dir["README*", "lib/**/*"]

    s.required_ruby_version     = '>= 1.8.7'
    s.required_rubygems_version = ">= 1.3.6"

    s.add_dependency("httparty", "~>0.7.0")
end
