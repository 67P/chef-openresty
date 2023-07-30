#
# Cookbook Name:: openresty
# Resource:: site
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

actions :enable, :disable

default_action :enable

property :name, kind_of: String, name_property: true
property :template, kind_of: String, default: nil
property :variables, kind_of: Hash, default: {}
property :cookbook, kind_of: String, default: nil
property :timing, [:delayed, :immediately], default: :delayed
property :redirect_http, kind_of: [TrueClass, FalseClass], default: true

action :enable do
  site_name = (new_resource.name == 'default') ? '000-default' : new_resource.name
  openresty_dir = node['openresty']['dir']

  if new_resource.template
    if new_resource.redirect_http
      template "#{openresty_dir}/sites-available/#{site_name}_http" do
        source "redirect_http.conf.erb"
        owner 'root'
        group 'root'
        mode 00644
        variables new_resource.variables
        cookbook 'openresty'
        if node['openresty']['service']['start_on_boot']
          notifies :reload, node['openresty']['service']['resource'], new_resource.timing
        end
      end

      link "#{openresty_dir}/sites-enabled/#{site_name}_http" do
        to "#{openresty_dir}/sites-available/#{site_name}_http"
        action :create
        notifies :reload, node['openresty']['service']['resource'], new_resource.timing
      end
    end

    template "#{openresty_dir}/sites-available/#{site_name}" do
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

  link "#{openresty_dir}/sites-enabled/#{site_name}" do
    to "#{openresty_dir}/sites-available/#{site_name}"
    action :create
    notifies :reload, node['openresty']['service']['resource'], new_resource.timing
  end
end

action :disable do
  site_name = (new_resource.name == 'default') ? '000-default' : new_resource.name
  openresty_dir = node['openresty']['dir']

  if new_resource.redirect_http
    link "#{openresty_dir}/sites-enabled/#{site_name}_http" do
      to "#{openresty_dir}/sites-available/#{site_name}_http"
      action :delete
      notifies :reload, node['openresty']['service']['resource'], new_resource.timing
    end
  end

  link "#{openresty_dir}/sites-enabled/#{site_name}" do
    to "#{openresty_dir}/sites-available/#{site_name}"
    action :delete
    notifies :reload, node['openresty']['service']['resource'], new_resource.timing
  end
end
