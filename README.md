# Development Setup

How to set up a development environment for [[imiq-map|https://github.com/gina-alaska/imiq-map]].
These directions should work for linux or macOS

[[See this projects Wiki for more infromation|https://github.com/gina-alaska/imiq-map/wiki/Development-Setup]]

## Contents
* Requiremnts 
* Install ruby
* Install postgress
* Imiq-map setup

## Requiremnts 
* Ruby 2.3.1
* bundler
* postgres

## Install ruby
Install ruby 2.3.1, it is recommended that you use [[ruby-install|https://github.com/postmodern/ruby-install]] and [[chruby|https://github.com/postmodern/chruby]]. 

`ruby-install ruby 2.3.1`

`chruby 2.3.1`

Note: the repo contains a .ruby-version file. If you set up chruby's [[auto switching|https://github.com/postmodern/chruby#auto-switching]] feature ruby 2.3.1 should automatically be set as the ruby version when you cd to the imiq-map directory if ruby 2.3.1 is installed on your system.


## Install postgress
At the [[postgress|https://www.postgresql.org/download/]] download web site follow the directions for the OS you are using. Mac users should use [[postgress.app|http://postgresapp.com]]

## Imiq-map setup 
Clone [[imiq-map|https://github.com/gina-alaska/imiq-map]] 

`git clone git@github.com:gina-alaska/imiq-map.git`

Change to the the repo. 

`cd imiq-map`

Check the ruby version. 

`ruby -v` 

If you used ruby-install and chruby it should show that ruby 2.3.1 is the version being used. If you are using those tools and the version is wrong run 

`chruby 2.3.1`.

Install dependencies

`bundle`, if not installed run `gem install bundler` first.

Setup the database and load the database seed information.

`rake db:setup`

Start up the web service, it should default to port 3000.  

`rails server`

To access it with your web browser, use the following URL: http://localhost:3000. 

At this point the map interface should be pointing at the production [[imiq-api|https://github.com/gina-alaska/imiq-api]]. If you want to point to a local development version of the api set the `imiq_api_url` under `development` in [[config/secrets.yml|https://github.com/gina-alaska/imiq-map/blob/master/config/secrets.yml]] to `http://localhost:3001`. You'll then need to set up the [[development api| https://github.com/gina-alaska/imiq-api/wiki/Development-Setup#imiq-api-setup]]
