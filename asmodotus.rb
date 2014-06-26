require 'camping'
require './auto_poet'

Camping.goes :Asmodotus

module Asmodotus::Controllers
  class Index
    def get
      @text = @input.q if @input.q.to_s =~ /\w/
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
      body do
        h1 { "Asmodotus" }
        h6 { 'Asmodotus uses google search autocomplete to make beautiful words' }
        div.content! do
          returns = AutoPoet.chain(@text).each {|t| p t}
          if returns.empty?
            p '-expletive deleted-'
          end
        end
        form :method => :get do
          input :type => :text, :name => :q
          input :type => :submit, :value => 'More'
        end
      end
    end
  end
end

__END__
@@ /main.css
body { background-color: #333; color: #fff }
h1, h6, p, form { font-family: monospace; text-align: center; }
form { margin-top: 100px; }
input[type='text'] { border: none; background-color: #000; color: #fff }