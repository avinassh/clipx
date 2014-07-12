require 'resque'
# See note in lib/tasks/resque.rake file about namespace being in two places
Resque.redis.namespace = "resque:clipx"