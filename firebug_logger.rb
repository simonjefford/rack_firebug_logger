class FirebugLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    dup._call(env)
  end

  def _call(env)
    status, headers, body = @app.call(env)
    return [status, headers, body] if !(headers["Content-Type"] =~ /html/)
    return [status, headers, body] unless env['firebug.logs']
    response = Rack::Response.new([], status, headers)
    body.each do |line|
    line.gsub!("</body>", "#{generate_js(env['firebug.logs'])}</body>")
      response.write(line)
    end
    response.finish
  end

  private

  def generate_js(logs)
    js = ["<script>"]
    js << "console.group(\"from web\");"
    logs.each do |log|
      log.gsub!('"', '\"')
      js << "console.info(\"#{log}\");"
    end
    js << "console.groupEnd();"
    js << "</script>"
    js.join("\n")
  end
end
