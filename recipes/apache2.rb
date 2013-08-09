arch = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i586"


execute "install apache2" do
  command "yum install httpd"
  action :run
end

service "httpd" do
  supports :status => true, :restart => true, :reload => true
  #action [ :enable, :start ]
end

node['apache2']['install_modules'].each do |mod_name, params|
  remote_file mod_name do
    source node['apache2']['modules'][mod_name][arch]['url']
    path "/etc/httpd/modules/mod_#{mod_name}.so"
    owner "root"
    group "root"
    mode "655"
  end
  template "/etc/httpd/mods-available/#{mod_name}.load" do
    source "apache2/#{mod_name}.load.erb"
  end
  template "/etc/httpd/mods-available/#{mod_name}.conf" do
    source "apache2/#{mod_name}.conf.erb"
  end
  if node['apache2']['modules'][mod_name]['enabled'] then
    link "/etc/httpd/mods-enabled/#{mod_name}.load" do
      to "/etc/httpd/mods-available/#{mod_name}.load"
    end
    link "/etc/httpd/mods-enabled/#{mod_name}.conf" do
      to "/etc/httpd/mods-available/#{mod_name}.conf"
    end
  end

  case mod_name
  when "jk" then
    template "/etc/httpd/jk.workers.properties" do
      source "apache2/jk.workers.properties.erb"
      owner "root"
      group "root"
      mode "664"
    end
  end
end

template "/etc/sysconfig/httpd" do
  source "apache2/sysconfig.httpd.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, resources(:service => "httpd"), :delayed
  #notifies :restart, "service[apache]", :delayed
end

=begin
package "apache" do
  action :install
end
=end
