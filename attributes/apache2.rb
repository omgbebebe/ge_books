default['apache2']['install_modules'] = ["auth_ntlm_winbind", "jk"]

default['apache2']['modules']['auth_ntlm_winbind']['i586']['url'] = "#{node['base_url']}/apache2/modules/mod_auth_ntlm_winbind.so_x86"
default['apache2']['modules']['auth_ntlm_winbind']['x86_64']['url'] = "#{node['base_url']}/apache2/modules/mod_auth_ntlm_winbind.so_x86"

default['apache2']['modules']['jk']['i586']['url'] = "#{node['base_url']}/apache2/modules/mod_jk.so.x86"
default['apache2']['modules']['jk']['x86_64']['url'] = "#{node['base_url']}/apache2/modules/mod_jk.so.x86_64"
default['apache2']['modules']['jk']['enabled'] = true
