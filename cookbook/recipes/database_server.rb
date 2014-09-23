include_recipe "imiq-map::_database_common"
include_recipe 'yum-epel'

node['imiq_map']['database']['environments'].each do |dbenv|
  dbinfo = node['imiq_map']['database'][dbenv]
  
  node.default['postgresql']['pg_hba'] += [{
  	:type => 'host', 
  	:db => dbinfo['database'], 
  	:user => dbinfo['username'], 
  	:addr => 'all', 
  	:method => 'trust'
  },{
    :type => 'host', 
    :db => 'postgres', 
    :user => dbinfo['username'], 
    :addr => 'all', 
    :method => 'trust'
  }]
end

include_recipe 'postgresql::server'
include_recipe 'database::default'
include_recipe 'postgresql::ruby'

postgresql_connection_info = {
	host: '127.0.0.1',
	port: 5432,
	username: 'postgres',
	password: node['postgresql']['password']['postgres']
}

node['imiq_map']['database']['environments'].each do |dbenv|
  dbinfo = node['imiq_map']['database'][dbenv]
  
  # Create a postgresql user but grant no privileges
  postgresql_database_user dbinfo['username'] do
    connection postgresql_connection_info
    password   dbinfo['password']
    action     :create
  end

  # create a postgresql database
  postgresql_database dbinfo['database'] do
    connection postgresql_connection_info
    owner dbinfo['username']
    action :create
  end


  # Grant all privileges on all tables in foo db
  postgresql_database_user dbinfo['username'] do
    connection    postgresql_connection_info
    database_name  dbinfo['database']
    privileges    [:all]
    action        :grant
  end

  #Ghetto way of doing it.
  #  Lets work on a postgis cookbook at soem point
  # package 'postgis2_92'
  # package 'postgis2_92-devel'

  #  Example what the dsl might look like
  # postgis_database dbinfo do
  #   action :create
  # end

  # bash 'enable_postgis' do
  #   user 'postgres'
  #   code <<-EOS
  #     psql -d #{dbinfo['database']} -c "ALTER ROLE #{dbinfo['username']} WITH CREATEDB"
  #     psql -d #{dbinfo['database']} -c "ALTER ROLE #{dbinfo['username']} WITH SUPERUSER"
  #     psql -d #{dbinfo['database']} -c "CREATE EXTENSION IF NOT EXISTS postgis;"
  #     psql -d #{dbinfo['database']} -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;"
  #   EOS
  # end
  #
  # package 'postgresql92-contrib'
  #
  # bash "install-hstore-extension" do
  #   user 'postgres'
  #   code <<-EOH
  #     echo 'CREATE EXTENSION IF NOT EXISTS "hstore";' | psql -d #{dbinfo['database']}
  #   EOH
  #   action :run
  # end
end