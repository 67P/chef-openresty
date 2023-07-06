#
# Cookbook Name:: openresty
# Attribute:: luarocks
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

default['openresty']['luarocks']['version']       = '3.9.2'
default['openresty']['luarocks']['url']           = "https://luarocks.org/releases/luarocks-#{node['openresty']['luarocks']['version']}.tar.gz"
default['openresty']['luarocks']['checksum']      = 'bca6e4ecc02c203e070acdb5f586045d45c078896f6236eb46aa33ccd9b94edb'
default['openresty']['luarocks']['default_rocks'] = Hash.new
