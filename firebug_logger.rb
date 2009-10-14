class FirebugLogger
  def initialize(app, options = {})
    @app = app
    @options = options
  end

  def call(env)
    dup._call(env)
  end

  def _call(env)
    status, headers, body = @app.call(env)
    return [status, headers, body] if !(headers["Content-Type"] =~ /html/)
    return [status, headers, body] unless env['firebug.logs']
    response = Rack::Response.new([], status, headers)
    js = generate_js(env['firebug.logs'])
    body.each do |line|
      line.gsub!("</body>", js)
      response.write(line)
    end
    response.finish
  end

  private

  def generate_js(logs)
    js = ["<script>"]
    start_group(js)
    logs.each do |level, log|
      level = sanitise_level(level)
      log.gsub!('"', '\"')
      js << "console.#{level.to_s}(\"#{log}\");"
    end
    end_group(js)
    js << "</script>"
    js << "</body>"
    js.join("\n")
  end

  def start_group(js)
    if @options[:group]
      js << "console.group(\"#{@options[:group]}\");"
    end
  end

  def sanitise_level(level)
    if [:info, :debug, :warn, :error].include?(level)
      level
    else
      :debug
    end
  end

  def end_group(js)
    if @options[:group]
      js << "console.groupEnd();"
    end
  end
end
