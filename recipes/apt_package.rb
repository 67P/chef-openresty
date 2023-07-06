# Cookbook Name:: openresty
# Recipe:: apt_package
#

openresty_dir = '/usr/local/openresty'

node.force_default['openresty']['service']['resource'] = 'service[openresty]'
node.force_default['openresty']['dir']                 = '/etc/openresty'
node.force_default['openresty']['log_dir']             = "/var/log/nginx/logs/"
node.force_default['openresty']['cache_dir']           = '/var/cache/nginx'
node.force_default['openresty']['binary']              = "#{openresty_dir}/nginx/sbin/nginx"
node.force_default['openresty']['pid']                 = "#{openresty_dir}/nginx/logs/nginx.pid"
# Needed to compile LuaRocks
node.force_default['openresty']['source']['prefix']    = openresty_dir

apt_repository 'openresty' do
  uri          "https://openresty.org/package/#{node['platform']}"
  distribution node['lsb']['codename']
  components   ['main']
  key          'https://openresty.org/package/pubkey.gpg'
end

package 'openresty'

service 'openresty' do
  supports :status => true, :restart => true, :reload => true
  if node['openresty']['service']['start_on_boot']
    action [ :enable, :start ]
  end
end

include_recipe 'openresty::ohai_plugin'
include_recipe 'openresty::commons_user'
include_recipe 'openresty::commons_dir'
include_recipe 'openresty::commons_script'
include_recipe 'openresty::commons_conf'
include_recipe 'openresty::luarocks'
