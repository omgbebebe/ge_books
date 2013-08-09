default['nexus']['home'] = "/var/lib/nexus/"
default['nexus']['user'] = "nexus"
default['nexus']['group'] = "nexus"
default['nexus']['port'] = "8081"
default['nexus']['host'] = "0.0.0.0"
default['nexus']['version'] = "2.6.0-05"
default['nexus']['package']['name'] = "nexus-#{node['nexus']['version']}-bundle.tar.gz"
default['nexus']['package']['url'] = "#{node['base_url']}/nexus/nexus-#{node['nexus']['version']}-bundle.tar.gz"

default['java']['jdk']['7']['home'] = "/usr/lib/jvm/jdk1.7.0_25"
default['java']['install_flavor'] = "oracle"
default['java']['jdk_version'] = "6"
#default['java']['oracle']['accept_oracle_download_terms'] = true
