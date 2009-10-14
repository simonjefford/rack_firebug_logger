require 'rubygems'
require 'sinatra'

class TestApp < Sinatra::Base
  get '/' do
    env['firebug.logs'] = [[:info, "Hi"]]
    "<html><body>Hello World</body></html>"
  end
end
