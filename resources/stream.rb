#
# Cookbook Name:: openresty
# Resource:: stream
#
# Author:: Kosmos Developers (<mail@kosmos.org>)
#
# Copyright 2023, Kosmos Developers
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

action :enable do
  openresty_dir = node['openresty']['dir']

  [ "#{openresty_dir}/streams-enabled",
    "#{openresty_dir}/streams-available" ].each do |dir|
    directory dir do
      owner 'root'
      group 'root'
      mode 00644
    end
  end

  stream_name = (new_resource.name == 'default') ? '000-default' : new_resource.name
  if new_resource.template
    template "#{openresty_dir}/streams-available/#{stream_name}" do
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

  link "#{openresty_dir}/streams-enabled/#{stream_name}" do
    to "#{openresty_dir}/streams-available/#{stream_name}"
    action :create
    notifies :reload, node['openresty']['service']['resource'], new_resource.timing
  end
end

action :disable do
  openresty_dir = node['openresty']['dir']

  link "#{openresty_dir}/streams-enabled/#{stream_name}" do
    to "#{openresty_dir}/streams-available/#{stream_name}"
    action :delete
    notifies :reload, node['openresty']['service']['resource'], new_resource.timing
  end
end
