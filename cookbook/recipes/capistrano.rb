app_name = 'imiq_map'
account = node[app_name]['account']

node[app_name]['paths'].each do |name, path|
  directory path do
    owner account
    group account
    mode 00755
    action :create
    recursive true
  end
end

# link "/home/webdev/#{app_name}" do
#   to node[app_name]['deploy_path']
#   owner account
#   group account
# end

link "/home/#{account}/#{app_name}" do
  to node[app_name]['paths']['deploy']
  owner node[app_name]['account']
  group node[app_name]['account']
end