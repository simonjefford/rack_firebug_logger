require 'rubygems'
require 'test/unit'
require 'hpricot'
require 'firebug_logger'
require 'rack'

class TestFirebugLogger < Test::Unit::TestCase
  def test_only_changes_output_when_content_type_is_html
    app = logger(inner_app("Content-Type" => "text/xml"))
    status, headers, body = app.call("firebug.logs" => [[:info, "Hello world"]])
    body_as_array = body_to_array(body)
    assert_equal default_body, body_to_array(body)
  end

  private

  # Needed because Rack::Response#to_a gives
  # you [status, headers, body] rather than body.to_a
  def body_to_array(body)
    body_as_array = []
    body.each do |line|
      body_as_array << line
    end
    body_as_array
  end

  def default_body
    ["<html><body>Logger test</body></html>"]
  end

  def logger(app, options = {})
    FirebugLogger.new(app, options)
  end

  def inner_app(headers = {}, body = default_body, status = 200)
    headers = { "Content-Type" => "text/html" }.merge(headers)
    lambda { |env| [status, headers, body] }
  end
end
