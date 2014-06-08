require 'spec_helper'

# pre-required for XL
describe package('uuid') do
  it { should be_installed }
end
describe package('libxslt') do
  it { should be_installed }
end
describe package('tcl') do
  it { should be_installed }
end

# XL - step 1
describe package('postgres-xl92') do
  it { should be_installed }
end
describe package('postgres-xl92-server') do
  it { should be_installed }
end
describe package('postgres-xl92-libs') do
  it { should be_installed }
end

# XL - step 2
describe package('postgres-xl92-contrib') do
  it { should be_installed }
end
describe package('postgres-xl92-debuginfo') do
  it { should be_installed }
end
describe package('postgres-xl92-devel') do
  it { should be_installed }
end
describe package('postgres-xl92-docs') do
  it { should be_installed }
end
describe package('postgres-xl92-gtm') do
  it { should be_installed }
end
describe package('postgres-xl92-plperl') do
  it { should be_installed }
end
describe package('postgres-xl92-plpython') do
  it { should be_installed }
end

# XL - step 3 with nodeps
describe package('postgres-xl92-pltcl') do
  it { should be_installed }
end

describe file('/var/lib/pgxl/9.2/data') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'pgxl' }
  it { should be_grouped_into 'pgxl' }
end

# ----------------------------------------------------------------
# Tests for GTM
# ----------------------------------------------------------------
describe file('/var/lib/pgxl/9.2/data/gtm') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'pgxl' }
  it { should be_grouped_into 'pgxl' }
end

describe file('/var/lib/pgxl/9.2/data/gtm/gtm.conf') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'pgxl' }
  it { should be_grouped_into 'pgxl' }
  its(:content) { should match /^port = 6666/ }
end

describe port(6666) do
  it { should be_listening }
end

# ----------------------------------------------------------------
# Tests for Data node
# ----------------------------------------------------------------
describe file('/var/lib/pgxl/9.2/data/data') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'pgxl' }
  it { should be_grouped_into 'pgxl' }
end

describe file('/var/lib/pgxl/9.2/data/data/PG_VERSION') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'pgxl' }
  it { should be_grouped_into 'pgxl' }
  its(:content) { should match /^9.2/ }
end

describe file('/var/lib/pgxl/9.2/data/data/postgresql.conf') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'pgxl' }
  it { should be_grouped_into 'pgxl' }
  its(:content) { should match /^listen_addresses = '*'/ }
  its(:content) { should match /^max_connections = 100/ }
  its(:content) { should match /^max_prepared_transactions = 10/ }
  its(:content) { should match /^pgxc_node_name = 'data'/ }
  its(:content) { should match /^port = 5433/ }
  its(:content) { should match /^gtm_port = 6666/ }
  its(:content) { should match /^gtm_host = 'localhost'/ }
  its(:content) { should match /^pooler_port = 6667/ }
  its(:content) { should match /^shared_queues = 64/ }
  its(:content) { should match /^shared_queue_size = 128kB/ }
end

describe port(5433) do
  it { should be_listening }
end

# Connection pooler
describe file('/tmp/.s.PGPOOL.6667') do
  it { should be_socket }
end


# ----------------------------------------------------------------
# Tests for Coordinator node
# ----------------------------------------------------------------
describe file('/var/lib/pgxl/9.2/data/coord') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'pgxl' }
  it { should be_grouped_into 'pgxl' }
end

describe file('/var/lib/pgxl/9.2/data/coord/PG_VERSION') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'pgxl' }
  it { should be_grouped_into 'pgxl' }
  its(:content) { should match /^9.2/ }
end

describe file('/var/lib/pgxl/9.2/data/coord/postgresql.conf') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'pgxl' }
  it { should be_grouped_into 'pgxl' }
  its(:content) { should match /^listen_addresses = '*'/ }
  its(:content) { should match /^max_connections = 100/ }
  its(:content) { should match /^max_prepared_transactions = 10/ }
  its(:content) { should match /^pgxc_node_name = 'coord'/ }
  its(:content) { should match /^port = 5432/ }
  its(:content) { should match /^gtm_port = 6666/ }
  its(:content) { should match /^gtm_host = 'localhost'/ }
  its(:content) { should match /^pooler_port = 6668/ }
  its(:content) { should match /^max_pool_size = 100/ }
#  its(:content) { should match /^min_pool_size = 1/ }
  its(:content) { should match /^pool_conn_keepalive = 600/ }
  its(:content) { should match /^pool_maintenance_timeout = 30/ }
  its(:content) { should match /^remote_query_cost = 100.0/ }
  its(:content) { should match /^network_byte_cost = 0.001/ }
  its(:content) { should match /^sequence_range = 1/ }
  its(:content) { should match /^max_coordinators = 16/ }
  its(:content) { should match /^max_datanodes = 16/ }
#  its(:content) { should match /^enforce_two_phase_commit = on/ }
end

describe port(5432) do
  it { should be_listening }
end

# Connection pooler
describe file('/tmp/.s.PGPOOL.6668') do
  it { should be_socket }
end
