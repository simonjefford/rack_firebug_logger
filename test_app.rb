require 'rubygems'
require 'sinatra'

class TestApp < Sinatra::Base
  get '/' do
    env['firebug.logs'] = ["Hi"]
    env['firebug.logs'] << "Blibble"
    env['firebug.logs'] << "Blobble"
    "<html><body>Hello World</body></html>"
  end
end
