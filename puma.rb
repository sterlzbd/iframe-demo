workers Integer(ENV['WEB_CONCURRENCY'] || 2)

preload_app!
log_requests

rackup      DefaultRackup if defined?(DefaultRackup)
port        ENV['PORT']     || 5001
environment ENV['RACK_ENV'] || 'development'
