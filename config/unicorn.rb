worker_processes 3

listen File.expand_path("/tmp/unicorn_eobackbone.sock", "/var/www/eobackbone/current")
pid File.expand_path("/tmp/unicorn_eobackbone.pid", "/var/www/eobackbone/current")

timeout 60

preload_app true

stdout_path File.expand_path("log/unicorn.stdout.log", "/var/www/eobackbone/current")
stderr_path File.expand_path("log/unicorn.stderr.log", "/var/www/eobackbone/current")

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  sleep 1
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
