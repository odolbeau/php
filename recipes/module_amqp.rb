#
# Author::  Chris Christensen (<chris@allplayers.com>)
# Author::  Olivier Dolbeau (<odolbeau@gmail.com>)
# Cookbook Name:: php
# Recipe:: module_amqp
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform']
when 'debian'
  package "pkg-config"

  git "#{Chef::Config[:file_cache_path]}/rabbitmq-c" do
    repository "git://github.com/alanxz/rabbitmq-c.git"
    reference "master"
    action :sync
    enable_submodules true
  end

  # from: http://www.php.net/manual/en/amqp.installation.php
  bash "install-phpamqplib" do
    code <<-EOH
    (cd #{Chef::Config[:file_cache_path]}/rabbitmq-c; autoreconf -i && ./configure && make && make install)
    EOH
    not_if { File.exists?("/usr/local/lib/librabbitmq.so") }
  end

  #php_pear 'amqp' do
    #preferred_state "beta"
    #action :install
  #end
  package 'php5-amqp' do
    action :install
  end
end
