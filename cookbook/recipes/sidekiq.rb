include_recipe 'imiq-map::redis'

app_name = "imiq_map"

template "/etc/init.d/sidekiq" do
  source "sidekiq_init.erb"
  action :create
  mode 00755
  variables({
    install_path: node[app_name]['paths']['deploy'],
    ruby_version: node[app_name]['ruby_version'],
    user: node[app_name]['account'],
    environment: node[app_name]['environment'],
    pidfile: node[app_name]['sidekiq']['pidfile'],
    redis_url: node[app_name]['redis']['url'],
    redis_environment: node[app_name]['redis']['environment']
  })
end

template ::File.join(node[app_name]['paths']['initializers'], 'sidekiq.rb') do
  source "sidekiq_initializer.rb.erb"
  owner node[app_name]['account']
  group node[app_name]['account']
  variables({
    url: node[app_name]['redis']['url'],
    namespace: node[app_name]['environment']
  })
end

template ::File.join(node[app_name]['paths']['config'], 'sidekiq.yml') do
  source "sidekiq.yml.erb"
  owner node[app_name]['account']
  group node[app_name]['account']
  variables({
    concurrency: node[app_name]['sidekiq']['concurrency'],
    pidfile: node[app_name]['sidekiq']['pidfile'],
    environments: node[app_name]['sidekiq']['environments']
  })
end

service "sidekiq" do
  action node[app_name]['sidekiq']['action']
end

service "sidekiq_#{app_name}" do
  action [:stop, :disable]
end


file "/etc/init.d/sidekiq_#{app_name}" do
  action :delete
end

