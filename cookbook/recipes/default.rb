#
# Cookbook Name:: imiq-map
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "imiq-map::packages"
include_recipe 'imiq-map::application'
include_recipe 'imiq-map::sidekiq'
include_recipe 'imiq-map::nginx'
include_recipe 'imiq-map::unicorn'
include_recipe "postfix::server"