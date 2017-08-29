#include_recipe "yum-gina"

#~ package "gina-ruby-19" do
  #~ action :install
#~ end

#~ package "gina-ruby-21" do
  #~ action :install
#~ end
include_recipe "ruby-install"

#~ ruby_install_ruby 'ruby 1.9'

#~ ruby_install_ruby 'ruby 2.1'

ruby_install_ruby 'ruby 2.2.4'



include_recipe "chruby"


