workers Integer(ENV['WEB_CONCURRENCY'] || 2)

preload_app!
log_requests

port ENV['PORT'] || 5001
