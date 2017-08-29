name             'imiq-map'
maintainer       'Will Fisher'
maintainer_email 'will@gina.alaska.edu'
license          'All rights reserved'
description      'Installs/Configures imiq-map-cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

supports "centos", ">= 6.0"

depends "chruby"
#~ depends 'yum-gina'
depends 'unicorn', '~> 1.3.0'
depends "nginx", '~> 2.6.0'
depends "sudo", '~> 2.5.2'
depends "postgresql"
depends 'database'
depends 'redisio', '~> 1.7.1'
depends 'postfix', '~> 3.6.0'
depends 'ruby-install'
depends 'ark'
