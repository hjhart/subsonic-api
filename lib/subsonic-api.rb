$:.unshift(File.dirname(__FILE__) + '/subsonic')

%w[
  httparty
  json
  awesome_print
].each do |file|
  require file
end

module Subsonic
  autoload :Client, File.join(File.expand_path(File.dirname(__FILE__)), "subsonic-rb", "client")
end
