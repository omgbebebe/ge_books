include_recipe 'java::oracle'

nexus_pkg_name = node['nexus']['package']['name']
nexus_pkg_path = "#{Chef::Config[:file_cache_path]}/#{nexus_pkg_name}"
nexus_user = node['nexus']['user']
nexus_group = node['nexus']['group']
nexus_home = node['nexus']['home']

# install jdk6 from Oracle
java_ark "jdk7" do
  url node['java']['jdk']['7']['x86_64']['url']
  checksum  node['java']['jdk']['7']['x86_64']['checksum']
  app_home '/usr/lib/jvm/java'
  #bin_cmds ["java", "javac"]
  action :install
end

remote_file nexus_pkg_path do
  source node['nexus']['package']['url']
  #action :create_if_missing
  action :create
end

group "nexus" do
  action :create
end

user "nexus" do
  home nexus_home
  group nexus_group
  action :create
end

Chef::Log.info("Hey I'm #{node[:tags]}")

directory node['nexus']['home'] do
  owner nexus_user
  group nexus_group
  mode "0755"
  action :create
end

execute "unpack nexus archive" do
  command "/bin/gzip -dc #{nexus_pkg_path} | /bin/tar zxf - --strip-components=1 -C #{node['nexus']['home']} && chown -R #{node['nexus']['user']}:#{node['nexus']['group']} #{node['nexus']['home']}"
  cwd "#{node['nexus']['home']}"
  action :run
  #notifies :create, "directory[#{node['nexus']['home']}]", :immediately
end

template "/etc/init.d/nexus" do
  source "nexus/init.d.erb"
  owner "root"
  group "root"
  mode "775"
  notifies :restart, "service[nexus]", :delayed
end

template "#{nexus_home}/conf/nexus.properties" do
  source "nexus/nexus.properties.erb"
  owner nexus_user
  group nexus_group
  mode "0664"
  notifies :restart, "service[nexus]", :delayed
end

service "nexus" do
  action :enable
end

=begin
ark "nexus" do
   url node['nexus']['package']['url']
   version node['nexus']['version']
   checksum node['nexus']['package']['checksum']
   path node['nexus']['home']
   strip_leading_dir true
   owner node['nexus']['user']
   action :put
end
=end
