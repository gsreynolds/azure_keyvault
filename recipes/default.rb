#
# Cookbook:: azure_keyvault
# Recipe:: default
#
# Copyright:: (c) Microsoft Open Technologies, Inc.

build_essential 'install' do
  compile_time true
  action :install
end

chef_gem 'azure_key_vault' do
  version node['azure_keyvault']['azure_key_vault_gem_version']
  action :install
  compile_time true
end
