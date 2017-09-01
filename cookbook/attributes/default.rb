#  Assuming webapp might use this variable at some point.
app_name = default['app_name'] = "imiq_map"
default['unicorn_config_path'] = '/etc/unicorn'
default['postfix']["mail_type"] = "master"
default['postfix']['main'] = {
  "mynetworks" => [ "127.0.0.0/8" ],
  "inet-interfaces" => "all",
  "mydomain" => "gina.alaska.edu",
  "myorigin" => "gina.alaska.edu"
}


default[app_name]['account'] = "webdev"
default[app_name]['environment'] = "production"

default[app_name]['application_path'] = "/www/#{app_name}"
default[app_name]['shared_path'] = "#{default[app_name]['application_path']}/shared"
default[app_name]['config_path'] = "#{default[app_name]['shared_path']}/config"
default[app_name]['initializers_path'] = "#{default[app_name]['config_path']}/initializers"
default[app_name]['deploy_path'] = "#{default[app_name]['application_path']}/current"

default['imiq_map']['paths'] = {
  application:        '/www/imiq_map',
  deploy:             '/www/imiq_map/current',
  shared:             '/www/imiq_map/shared',
  config:             '/www/imiq_map/shared/config',
  initializers:       '/www/imiq_map/shared/config/initializers',
  public:             '/www/imiq_map/shared/public',
  log:                '/www/imiq_map/shared/log',
  tmp:                '/www/imiq_map/shared/tmp',
  pids:               '/www/imiq_map/shared/tmp/pids',
  sockets:            '/www/imiq_map/shared/tmp/sockets'
}

default['imiq_map']['ruby_version'] = '2.2.4'

default['imiq_map']['database'] = {
  setup: false,
  environments: [:development, :test],
  development: {
    adapter: 'postgresql',
    hostname: 'localhost',
    database: 'imiq_map_development',
    username: 'imiq',
    password: 'fj188fj1lmff14r',
    search_path: 'public'
  },
  test: {
    adapter: 'postgresql',
    hostname: 'localhost',
    database: 'imiq_map_test',
    username: 'imiq',
    password: 'fj329rghDDw02jf',
    search_path: 'public'    
  },
  production: {
    adapter: 'postgresql',
    hostname: 'yin.gina.alaska.edu',
    database: 'imiq_map_production',
    username: 'imiq',
    password: '',
    search_path: 'public'
  }
}

# default[app_name]['database']['adapter']  = "postgresql"
# default[app_name]['database']['hostname'] = "yin.gina.alaska.edu"
# default[app_name]['database']['database'] = "imiq_map_production"
# default[app_name]['database']['username'] = "imiq"
# default[app_name]['database']['password'] = "1m1q1swunderful"
# default[app_name]['database']['search_path'] = "public"

# default[app_name]['sunspot']['hostname'] = "localhost"
# default[app_name]['sunspot']['port'] = "8983"

default[app_name]['rails']['secrets']['secret_key_base'] = 'de4a62bd614a174db51dd40fbd22f4b29270040706976d36895baace8faaa53e78693c4eb2208ae150abbd93eb38ea6e96ddf7c897e389c93a38f24a247c9de0'
default[app_name]['rails']['secrets']['google_key'] = ""
default[app_name]['rails']['secrets']['google_secret'] = ""
default[app_name]['rails']['secrets']['github_key'] = ""
default[app_name]['rails']['secrets']['github_secret'] = ""

default[app_name]['redis']['url'] = "redis://localhost:6379/12"
default[app_name]['redis']['environment'] = "production"


#Sidekiq Configuration
default[app_name]['sidekiq']['action'] = [:enable]
default[app_name]['sidekiq']['pidfile'] = 'tmp/pids/sidekiq.pid'
default[app_name]['sidekiq']['concurrency'] = 1
default[app_name]['sidekiq']['environments'] = {
  'development' => {
    'concurrency' => 1
  },
  'production' => {
    'concurrency' => 2
  }
}


default[app_name]['package_deps'] = %w{libicu-devel curl-devel libxml2-devel libxslt-devel nfs-utils ImageMagick-devel nodejs}

default['unicorn']['preload_app'] = true
default['unicorn']['config_path'] = '/etc/unicorn/imiq_api.rb'
default['unicorn']['listen'] = "unicorn.socket"
default['unicorn']['pid'] = "unicorn.pid"
default['unicorn']['stderr'] = "unicorn.stderr.log"
default['unicorn']['stdout'] = "unicorn.stdout.log"
default['unicorn']['worker_timeout'] = 60
default['unicorn']['before_fork'] = '
defined?(ActiveRecord::Base) and
   ActiveRecord::Base.connection.disconnect!

 old_pid = "#{server.config[:pid]}.oldbin"
 if old_pid != server.pid
   begin
     sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
     Process.kill(sig, File.read(old_pid).to_i)
   rescue Errno::ENOENT, Errno::ESRCH
   end
 end

sleep 1
'

default['unicorn']['after_fork'] = "
defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection

# If you are using Redis but not Resque, change this
# if defined?(Resque)
#   Resque.redis.client.reconnect
# end
"

# default['users'] ||= []
# %w{ webdev }.each do |user|
#   default['users'] << user unless default['users'].include?(user)
# end

#sudo stuff
default['authorization']['sudo']['include_sudoers_d'] = true

#postgresql client stuff
override['postgresql']['enable_pgdg_yum'] = true
override['postgresql']['version'] = "9.2"
