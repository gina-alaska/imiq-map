app_name = node['app_name']
account = node[app_name]['account']

sudo account do
  user      account    # or a username
  runas     "root"   # or 'app_user:tomcat'
  nopasswd  true
  commands  [
    "/sbin/service unicorn_#{app_name.gsub('-', '_').downcase} restart",
    "/sbin/service unicorn_#{app_name.gsub('-', '_').downcase} stop",
    "/sbin/service unicorn_#{app_name.gsub('-', '_').downcase} start",
    "/sbin/service sidekiq_#{app_name.gsub('-', '_').downcase} restart",
    "/sbin/service sidekiq_#{app_name.gsub('-', '_').downcase} stop",
    "/sbin/service sidekiq_#{app_name.gsub('-', '_').downcase} start"
  ]
end
