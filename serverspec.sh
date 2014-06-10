#!/bin/sh

PATH=/opt/chef/embedded/bin:$PATH
export PATH

cd serverspec
if [ ! -d vendor/bundle ]; then
  /opt/chef/embedded/bin/bundle install --path vendor/bundle
fi

/opt/chef/embedded/bin/bundle exec /opt/chef/embedded/bin/rake spec
