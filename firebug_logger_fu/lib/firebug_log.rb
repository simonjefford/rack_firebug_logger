module FirebugLog
  mattr_accessor :enabled

  class BrowserLogger
    attr_reader :request
    def initialize(request)
      @request = request
      request.env['firebug.logs'] ||= []
    end

    [:info, :debug, :warn, :error].each do |level|
      define_method level do |message|
        if FirebugLog.enabled
          request.env['firebug.logs'] << [level, message]
        end
      end
    end
  end

  def browser_logger
    @browser_logger ||= BrowserLogger.new(request)
  end
end
