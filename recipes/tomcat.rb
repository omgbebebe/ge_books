tomcat_user = node['tomcat']['user']
tomcat_group = node['tomcat']['group']
tomcat_home = node['tomcat']['home']
tomcat_pkg_url = node['tomcat']['package']['url']
tomcat_pkg_checksum = node['tomcat']['package']['checksum']

group tomcat_group do
  action :create
end

user tomcat_user do
  group tomcat_group
  home tomcat_home
  shell "/bin/bash"
  comment "Tomcat Service Account"
  action :create
end

directory tomcat_home do
  owner tomcat_user
  group tomcat_group
  mode "775"
  action :create
end

remote_file "/tmp/tomcat.tar.gz" do
  source tomcat_pkg_url
end

execute "unpack tomcat archive" do
  command "/bin/gzip -dc /tmp/tomcat.tar.gz | /bin/tar zxvf - --strip-components=1 && chown -R #{tomcat_user}:#{tomcat_group} ./"
  cwd tomcat_home
end
 
template "/etc/init.d/tomcat" do
  source "tomcat/init.d.erb"
  owner "root"
  group "root"
  mode "775"
  notifies :restart, "service[tomcat]", :immediately
end

service "tomcat" do
  action :nothing
end
