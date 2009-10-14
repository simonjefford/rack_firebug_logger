module FirebugLog
  class BrowserLogger
    attr_reader :request
    def initialize(request)
      @request = request
      request.env['firebug.logs'] ||= []
    end

    [:info, :debug, :warn, :error].each do |level|
      define_method level do |message|
        request.env['firebug.logs'] << [level, message]
      end
    end
  end

  def browser_logger
    @browser_logger ||= BrowserLogger.new(request)
  end
end
