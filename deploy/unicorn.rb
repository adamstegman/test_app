app_dir = "/opt/test_app"

working_directory app_dir

pid "/var/run/unicorn.pid"

stderr_path "/var/log/unicorn.stderr.log"
stdout_path "/var/log/unicorn.stdout.log"

listen "/tmp/unicorn.sock", :backlog => 64

worker_processes Integer(ENV["UNICORN_CONCURRENCY"] || 1)
timeout Integer(ENV['UNICORN_TIMEOUT'] || 15) # seconds
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
