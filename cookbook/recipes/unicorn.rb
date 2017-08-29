user node['imiq_map']['account']

directory node['unicorn']['listen'] do
 user node['imiq_map']['account']
 group node['imiq_map']['account']
 recursive true
 action :create
end

unicorn_config node['unicorn']['config_path'] do
  # preload_app node['unicorn']['preload_app']
  preload false
  listen ::File.join(node['imiq_map']['paths']['sockets'], node['unicorn']['listen']).to_s => {backlog: 1024}
  pid ::File.join(node['imiq_map']['paths']['pids'], node['unicorn']['pid']).to_s
  stderr_path ::File.join(node['imiq_map']['paths']['log'], node['unicorn']['stderr']).to_s
  stdout_path ::File.join(node['imiq_map']['paths']['log'], node['unicorn']['stdout']).to_s
  worker_timeout node['unicorn']['worker_timeout']
  worker_processes [node['cpu']['total'].to_i * 4, 2].min
  working_directory node['imiq_map']['paths']['deploy']
  before_fork node['unicorn']['before_fork']
  after_fork node['unicorn']['after_fork']
end

template "/etc/init.d/unicorn" do
  source "unicorn_init.erb"
  action :create
  mode 00755
  variables({
    install_path: node['imiq_map']['paths']['deploy'],
    user: node['imiq_map']['account'],
    pidfile: ::File.join(node['imiq_map']['paths']['pids'], node['unicorn']['pid']).to_s,
    unicorn_config_file: node['unicorn']['config_path'],
    environment: node['imiq_map']['environment'],
    ruby_version: "2.2.4"
  })
end

service "unicorn" do 
  action [:enable]
end
