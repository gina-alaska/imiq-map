app_name = node['app_name']

include_recipe 'yum-epel'

node[app_name]['package_deps'].each do |pkg|
  package pkg do
    action :install
  end
end
