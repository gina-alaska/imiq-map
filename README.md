[![Stories in Ready](https://badge.waffle.io/gina-alaska/imiq-map.png?label=ready&title=Ready)](https://waffle.io/gina-alaska/imiq-map)
## Requirements
* Ruby 2.0
* Rails 4.0.1
* NodeJS
* Bower (npm install -g bower)
* PostgreSQL
* Otto (https://ottoproject.io/downloads.html)

## Installation

Checkout the code

    git clone <repo>
    bundle
    cp config/database.yml.example config/database.yml
    cp config/secrets.yml.example config/secrets.yml
    vim config/database.yml #add the appropriate values
    
    # start up the server / browser
    rails server
    # setup the database
    rake db:setup
    # seed data into the database
    rake db:seed

### Setup Ruby

This application requires ruby 2.1.1


In OSX run the following commands

    brew update
    brew upgrade rbenv ruby-install
    rbenv install 2.1.1
    gem install bundler
    bundle
