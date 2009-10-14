class TestController < ApplicationController
  def index
    browser_logger.debug "this is a debug message"
    browser_logger.info "this is an info message"
    browser_logger.error "this is an error message"
  end
end
