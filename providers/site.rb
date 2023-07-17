#
# Cookbook Name:: openresty
# Provider:: site
#
# Author:: Panagiotis Papadomitsos (<pj@ezgr.net>)
#
# Copyright 2012, Panagiotis Papadomitsos
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

use_inline_resources

action :enable do
  site_name = (new_resource.name == 'default') ? '000-default' : new_resource.name
  if new_resource.template
    template "#{node['openresty']['dir']}/sites-available/#{site_name}" do
      source new_resource.template
      owner 'root'
      group 'root'
      mode 00644
      variables new_resource.variables
      cookbook new_resource.cookbook
      if node['openresty']['service']['start_on_boot']
        notifies :reload, node['openresty']['service']['resource'], new_resource.timing
      end
    end
  end
  execute "nxensite #{site_name}" do
    command "/usr/sbin/nxensite #{site_name}"
    notifies :reload, node['openresty']['service']['resource'], new_resource.timing
    not_if { ::File.symlink?("#{node['openresty']['dir']}/sites-enabled/#{site_name}") }
  end
end

action :disable do
  site_name = (new_resource.name == 'default') ? '000-default' : new_resource.name
  execute "nxdissite #{site_name}" do
    command "/usr/sbin/nxdissite #{site_name}"
    if node['openresty']['service']['start_on_boot']
      notifies :reload, node['openresty']['service']['resource'], new_resource.timing
    end
    only_if { ::File.symlink?("#{node['openresty']['dir']}/sites-enabled/#{site_name}") }
  end
end
