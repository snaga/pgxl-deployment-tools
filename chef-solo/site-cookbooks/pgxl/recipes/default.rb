#
# Cookbook Name:: pgxl
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Pre-required for PGXL
%w{uuid libxslt tcl}.each do |pkg|
  yum_package pkg do
    action :install
  end
end

cookbook_file "/tmp/postgres-xl92-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "4b21b46a2f0a122f7c35be6ff9afe12846260ed6964e74c4265c68a6aa3c3304"
end
cookbook_file "/tmp/postgres-xl92-contrib-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "5cb74cc2a2cc76ff4de8658fa667b0edc726d6d9a0340830c5026933410c0468"
end
cookbook_file "/tmp/postgres-xl92-debuginfo-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "8d957b1d865a24f3ee57408295bb4a0546635b63074b7cd93a5731c291a9439e"
end
cookbook_file "/tmp/postgres-xl92-devel-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "0bb904308fca9267f43807f697191022d4900d5baed3411369d8f60cc03b4f8e"
end
cookbook_file "/tmp/postgres-xl92-docs-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "339578617b15d39d31d43b15c8f43d8cf8f056af43521e068becad6551b6378a"
end
cookbook_file "/tmp/postgres-xl92-gtm-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "c1074f0e17767bb4e3c7e6ae3590a8491eb13356f9e293077cdc662b144d011f"
end
cookbook_file "/tmp/postgres-xl92-libs-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "026400c94c52b4dced3aee6f20969de0bdc0fe45e4a1e5462cfd4ed2a2003479"
end
cookbook_file "/tmp/postgres-xl92-plperl-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "6107a26934e362ebf06db92035cc39c5822de2e91ea23d516fa16e9f0a908690"
end
cookbook_file "/tmp/postgres-xl92-plpython-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "bf0a50b64f08b78357a87db20613631c6ed2629efd6e6045ad3c159a6f7a97f1"
end
cookbook_file "/tmp/postgres-xl92-pltcl-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "51d1c6e540f004fee20a1cb27ff4e9a252f7b8ac7f5ea238e2822a6a9b6c0a62"
end
cookbook_file "/tmp/postgres-xl92-pltcl-9.2-34.1.x86_64.rpm" do
  mode 00644
  checksum "548deee20f9ecbd11965f923d760eb68955bf47dfd13c54eeda7a679907cc4c2"
end

package "postgres-xl92" do
  source "/tmp/postgres-xl92-9.2-34.1.x86_64.rpm"
  action :install
end
package "postgres-xl92-contrib" do
  source "/tmp/postgres-xl92-contrib-9.2-34.1.x86_64.rpm"
  action :install
end
package "postgres-xl92-debuginfo" do
  source "/tmp/postgres-xl92-debuginfo-9.2-34.1.x86_64.rpm"
  action :install
end
package "postgres-xl92-devel" do
  source "/tmp/postgres-xl92-devel-9.2-34.1.x86_64.rpm"
  action :install
end
package "postgres-xl92-docs" do
  source "/tmp/postgres-xl92-docs-9.2-34.1.x86_64.rpm"
  action :install
end
package "postgres-xl92-gtm" do
  source "/tmp/postgres-xl92-gtm-9.2-34.1.x86_64.rpm"
  action :install
end
package "postgres-xl92-libs" do
  source "/tmp/postgres-xl92-libs-9.2-34.1.x86_64.rpm"
  action :install
end
package "postgres-xl92-plperl" do
  source "/tmp/postgres-xl92-plperl-9.2-34.1.x86_64.rpm"
  action :install
end
package "postgres-xl92-plpython" do
  source "/tmp/postgres-xl92-plpython-9.2-34.1.x86_64.rpm"
  action :install
end
package "postgres-xl92-pltcl" do
  source "/tmp/postgres-xl92-pltcl-9.2-34.1.x86_64.rpm"
  action :install
end
package "postgres-xl92-pltcl" do
  source "/tmp/postgres-xl92-pltcl-9.2-34.1.x86_64.rpm"
  action :install
end

# -----------------------------------------------------------
# GTM
# -----------------------------------------------------------
directory "/var/lib/pgxl/9.2/data/gtm" do
  owner "pgxl"
  group "pgxl"
  mode 00700
  action :create
end

bash 'initgtm' do
  user "pgxl"
  code <<-EOH
    /usr/postgres-xl-9.2/bin/initgtm -D /var/lib/pgxl/9.2/data/gtm -Z gtm
    EOH
  not_if { File.exists?("/var/lib/pgxl/9.2/data/gtm/gtm.conf") }
end

template "/var/lib/pgxl/9.2/data/gtm/gtm.conf" do
  source "gtm.conf.erb"
  mode 0600
  owner "pgxl"
  group "pgxl"
end

# Using chown command instead of 'directory recursive' resource
# because the resource does not work correctly.
bash 'chown' do
  user "root"
  code <<-EOH
    chown -R pgxl:pgxl /var/lib/pgxl/9.2/data/gtm
    EOH
end

#directory "/var/lib/pgxl/9.2/data/gtm" do
#  owner "pgxl"
#  group "pgxl"
#  recursive true
#end

bash 'gtm_ctl_start' do
  user "pgxl"
  code <<-EOH
    /usr/postgres-xl-9.2/bin/gtm_ctl -Z gtm -p /usr/postgres-xl-9.2/bin start -D /var/lib/pgxl/9.2/data/gtm
    EOH
  not_if { File.exists?("/var/lib/pgxl/9.2/data/gtm/gtm.pid") }
end


# -----------------------------------------------------------
# Coordinator
# -----------------------------------------------------------
directory "/var/lib/pgxl/9.2/data/coord" do
  owner "pgxl"
  group "pgxl"
  mode 00700
  action :create
end

bash 'initdb' do
  user "pgxl"
  code <<-EOH
    /usr/postgres-xl-9.2/bin/initdb -D /var/lib/pgxl/9.2/data/coord --no-locale --nodename coord
    EOH
  not_if { File.exists?("/var/lib/pgxl/9.2/data/coord/postgresql.conf") }
end

template "/var/lib/pgxl/9.2/data/coord/postgresql.conf" do
  source "postgresql-coord.conf.erb"
  mode 0600
  owner "pgxl"
  group "pgxl"
end

# Using chown command instead of 'directory recursive' resource
# because the resource does not work correctly.
bash 'chown' do
  user "root"
  code <<-EOH
    chown -R pgxl:pgxl /var/lib/pgxl/9.2/data/coord
    EOH
end

#directory "/var/lib/pgxl/9.2/data/coord" do
#  owner "pgxl"
#  group "pgxl"
#  recursive true
#end

bash 'pg_ctl_start' do
  user "pgxl"
  code <<-EOH
    /usr/postgres-xl-9.2/bin/pg_ctl -D /var/lib/pgxl/9.2/data/coord -Z coordinator start
    EOH
  not_if { File.exists?("/var/lib/pgxl/9.2/data/coord/postmaster.pid") }
end


# -----------------------------------------------------------
# Datanode
# -----------------------------------------------------------
directory "/var/lib/pgxl/9.2/data/data" do
  owner "pgxl"
  group "pgxl"
  mode 00700
  action :create
end

bash 'initdb' do
  user "pgxl"
  code <<-EOH
    /usr/postgres-xl-9.2/bin/initdb -D /var/lib/pgxl/9.2/data/data --no-locale --nodename data
    EOH
  not_if { File.exists?("/var/lib/pgxl/9.2/data/data/postgresql.conf") }
end

template "/var/lib/pgxl/9.2/data/data/postgresql.conf" do
  source "postgresql-data.conf.erb"
  mode 0600
  owner "pgxl"
  group "pgxl"
end

# Using chown command instead of 'directory recursive' resource
# because the resource does not work correctly.
bash 'chown' do
  user "root"
  code <<-EOH
    chown -R pgxl:pgxl /var/lib/pgxl/9.2/data/data
    EOH
end

#directory "/var/lib/pgxl/9.2/data/data" do
#  owner "pgxl"
#  group "pgxl"
#  recursive true
#end

bash 'pg_ctl_start' do
  user "pgxl"
  code <<-EOH
    /usr/postgres-xl-9.2/bin/pg_ctl -D /var/lib/pgxl/9.2/data/data -Z datanode start
    EOH
  not_if { File.exists?("/var/lib/pgxl/9.2/data/data/postmaster.pid") }
end
