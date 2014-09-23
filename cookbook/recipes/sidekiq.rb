app_name = node['app_name']

template "/etc/init.d/sidekiq_#{app_name}" do
  source "sidekiq_init.erb"
  action :create
  mode 00755
  variables({
    install_path: node[app_name]['deploy_path'],
  })
end

service "sidekiq_#{app_name}" do 
  action :enable
end

account = node[app_name]['account']
sudo "#{account}_sidekiq" do
  user      account    # or a username
  runas     "root"   # or 'app_user:tomcat'
  nopasswd  true
  commands  [
    "/sbin/service sidekiq_#{app_name.gsub('-', '_').downcase} restart",
    "/sbin/service sidekiq_#{app_name.gsub('-', '_').downcase} stop",
    "/sbin/service sidekiq_#{app_name.gsub('-', '_').downcase} start"
  ]
end
