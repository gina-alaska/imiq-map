set :application, 'imiq_map'
set :repo_url, 'https://github.com/gina-alaska/imiq-map.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/www/imiq_map'
set :scm, :git

set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets solr vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    puts "We currently don't have support for auto restarting, please login to browse-web0 and run 'sudo service unicorn_browser_ng restart'"
    on roles(:web), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      # within release_path do
      #   execute :rake, 'sunspot:solr:stop'
      #   execute :rake, 'sunspot:solr:start'
      # end
      execute 'sudo service unicorn_imiq_map stop'
      execute 'sudo service unicorn_imiq_map start'
    end
  end

  after :finishing, 'deploy:cleanup'

end
