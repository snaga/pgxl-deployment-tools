#!/bin/sh

# Install chef and knife.
if [ ! -x /opt/chef/bin/chef-solo ]; then
  curl -L https://www.opscode.com/chef/install.sh | bash
  /opt/chef/embedded/bin/gem i knife-solo --no-ri --no-rdoc
fi

# Install serverspec and deps.
if [ ! -x /opt/chef/embedded/bin/serverspec-init ]; then
  /opt/chef/embedded/bin/gem install bundler --no-ri --no-rdoc
  /opt/chef/embedded/bin/gem install rspec-core rspec-support rspec-expectations --no-ri --no-rdoc
  /opt/chef/embedded/bin/gem install serverspec --no-ri --no-rdoc
fi

