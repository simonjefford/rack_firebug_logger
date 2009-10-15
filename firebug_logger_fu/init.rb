ActionController::Base.send :include, FirebugLog
ActionController::Dispatcher.middleware.use FirebugLogger
