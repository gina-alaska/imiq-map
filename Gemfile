source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
gem 'bundler', '>= 1.8.4'

gem 'dotenv-rails', :require => 'dotenv/rails-now'

# Use sqlite3 as the database for Active Record
gem 'pg'
gem 'haml'

gem 'httparty'
gem 'quiet_assets'
gem 'sidekiq'
gem 'redis-namespace'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'spring', group: :development
gem "chartkick"
gem 'kaminari'
gem 'foreman'
gem 'cancancan', '~> 1.10'

#heroku gems
#gem 'rails_12factor', group: :production

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn', group: :production
gem 'puma', group: :development

# Use Capistrano for deployment
# gem 'capistrano', group: :development
gem 'capistrano', group: :development
gem 'capistrano-chruby', github: "capistrano/chruby"
gem 'capistrano-bundler'
gem 'capistrano-rails'
gem 'capistrano-bower'

# Use debugger
# gem 'debugger', group: [:development, :test]
#ruby '2.1.1'

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap', '3.2.0'
  gem 'rails-assets-mapbox.js'
  gem 'rails-assets-leaflet-draw'
  gem 'rails-assets-leaflet.markercluster', '0.4.0.hotfix.1'
  gem 'rails-assets-Leaflet.Coordinates'
  gem 'rails-assets-highcharts'
  gem 'rails-assets-eonasdan-bootstrap-datetimepicker'
  gem 'rails-assets-jquery.xdomainrequest'
end
gem "font-awesome-rails"

group :development, :test do
  gem 'web-console', '~> 2.0'
end

gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-openid'
gem 'google-api-client'
