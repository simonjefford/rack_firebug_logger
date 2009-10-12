require 'rubygems'
require 'sinatra'

class TestApp < Sinatra::Base
  get '/' do
    "Hello World"
    env['log'] = "Hi"
  end
end
