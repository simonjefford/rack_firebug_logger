require 'rubygems'
require 'test/unit'
require 'hpricot'
require 'firebug_logger'
require 'rack'

class TestFirebugLogger < Test::Unit::TestCase
  def test_only_changes_output_when_content_type_is_html
    app = logger(inner_app("Content-Type" => "text/xml"))
    status, headers, body = app.call("firebug.logs" => [[:info, "Hello world"]])
    assert_body_equal default_body, body
  end

  def test_only_changes_output_when_something_is_logged
    app = logger(inner_app)
    status, headers, body = app.call({})
    assert_body_equal default_body, body
  end

  def test_logs_to_expected_level
    app = logger(inner_app)
    status, headers, body = app.call("firebug.logs" => [[:info, "Hello world"]])
    assert_logged :info, "Hello world", body
  end

  def test_logs_to_debug_if_level_is_not_supported
    app = logger(inner_app)
    status, headers, body = app.call("firebug.logs" => [[:rubbish, "Hello world"]])
    assert_logged :debug, "Hello world", body
  end

  def test_multiple_logs
    app = logger(inner_app)
    status, headers, body = app.call("firebug.logs" => [[:debug, "log1"],[:info, "log2"]])
    assert_logged :debug, "log1", body
    assert_logged :info, "log2", body
  end

  def test_grouping
    app = logger(inner_app, :group => "Mygroup")
    status, headers, body = app.call("firebug.logs" => [[:info, "log"]])
    assert_group "Mygroup", body
  end

  private

  def get_hpricot_doc_from_body(body)
    output = body_to_array(body).join("\n")
    Hpricot(output)
  end

  def assert_logged(level, message, body)
    doc = get_hpricot_doc_from_body(body)
    script = doc.at("script").inner_html
    assert_match /console.#{level}\("#{message}"\)/, script
  end

  def assert_group(name, body)
    doc = get_hpricot_doc_from_body(body)
    script = doc.at("script").inner_html
    assert_match /console.group\("#{name}"\)/, script
  end

  def assert_body_equal(expected, actual)
    actual_as_array = body_to_array(actual)
    assert_equal expected, actual_as_array
  end

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
