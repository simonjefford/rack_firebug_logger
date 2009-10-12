require 'test_app'
require 'rack_firebug_logger'

use Rack::FirebugLogger
run TestApp
