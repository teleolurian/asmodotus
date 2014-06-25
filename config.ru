require 'rack/adapter'
require './asmodotus'
run Rack::Adapter::Camping.new(Asmodotus)
