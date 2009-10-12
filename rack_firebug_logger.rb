module Rack
  class FirebugLogger
    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      status, headers, body = @app.call(env)
      headers['X-Middleware'] = 'Woohoo'
      puts @app.inspect
      newbody = body[0]
      puts newbody.class
      newbody = newbody + "<script>console.log(\"#{env['log']}\")</script>"
      headers['Content-Length'] = newbody.length.to_s
      [status, headers, [newbody]]
    end
  end
end
