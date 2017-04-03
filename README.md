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

## Using otto

1. Checkout repo
2. Install otto
3. If this is the first time starting up the development vm you'll need to do a few extra steps

  ```bash
  # create otto config files
  otto compile

  # startup and provision the vm
  otto dev # it should spit out an ipaddress copy that or run the following command to find it later

  # Note that there is currently a bug with otto and the first time building of rails app vm,
  # so you'll need to reboot it to fix the problem
  otto dev halt
  otto dev

  # login to the vm
  otto dev ssh

  # get your dependancies setup
  bundle

  # build the database
  rake db:setup
  ```

4. Start up the development vm in general

  ```bash

  # this will start vm if it's not already running
  otto dev
  # make a note of the ip
  otto dev address
  # log into the vm
  otto dev ssh
  # start the rails server
  foreman start
  ```
