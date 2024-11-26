# Puma Configuration File

# Number of threads to use (min and max).
threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
threads threads_count, threads_count

# Port Puma will listen on
port ENV.fetch("PORT", 3001)

# Environment (default: production)
environment ENV.fetch("RAILS_ENV", "production")

# Number of Puma workers (default: 2)
workers ENV.fetch("WEB_CONCURRENCY", 2)

# Preload the application before forking workers for performance
preload_app!

# Re-establish connections for ActiveRecord on worker boot
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Allow Puma to be restarted by `bin/rails restart`
plugin :tmp_restart

# Specify the PID file (if applicable)
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Redirect logs to stdout and stderr
stdout_redirect nil, nil, true
