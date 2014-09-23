app_path '/www/imiq_map/current'
chruby.environment 2.1
startup ['bundle install', 'service unicorn start']
