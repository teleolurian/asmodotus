require 'camping'
require './auto_poet'

Camping.goes :Asmodotus

module Asmodotus::Controllers
  class Index
    def get
      render :index
    end
  end
end

module Asmodotus::Views
  def index
    html do
      head do
        link rel: 'stylesheet', href: 'main.css'
      end
    end
    h1 { "Asmodotus" }
    h6 { 'Asmodotus uses google search autocomplete to make beautiful words' }
    div.content! do
      AutoPoet.chain.each {|t| p t}
    end
  end
end

__END__
@@ /main.css
body { background-color: #333; color: #fff }
h1, h6, p { font-family: monospace; text-align: center; }