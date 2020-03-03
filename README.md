# Azure Key Vault Chef Cookbook

# Description

This is a fork of the [azure-cookbook](https://github.com/chef-partners/azure-cookbook), paired down to only support Azure Key Vault (AKV). This reduces dependancies, making the cookbook easier to support and forces it to do one thing well. This cookbook allows Chef users the option to use Azure Key Vault as a main secret store instead of Chef encrypted data bags. The library has also been refactored to use the official [Azure SDK for Ruby](https://github.com/Azure/azure-sdk-for-ruby).

# Requirements

* **Create an Azure Key Vault:** You'll need to create a vault in Azure. Either in the [portal](https://docs.microsoft.com/en-us/azure/key-vault/quick-create-portal) or [CLI](https://docs.microsoft.com/en-us/azure/key-vault/key-vault-manage-with-cli2). I recommend creating a vault just for your Chef secrets, instead of reusing one being used for other purposes.
* **Create a principal to access your Vault:** You'll need to create an Azure principal or Identity 
 and provide permissions to it. (see below)

## Azure Credentials

 Reasonable options include:

* [A Managed Identity for an Azure VM](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-use-vm-token)
  * Once created, you'll need a programatic way to [assign the VM access](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/howto-assign-access-portal) to your Azure Key Vault resource
* [A service principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) which can be [created with the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest)

You'll need to ensure that appropriate permissions are granted to your Keyvault once created.

I've created a short tutorial on this subject [here](https://github.com/kriszentner/technotes/blob/master/Azure/create_keyvault_with_sp.md):


In order to access the Azure Key Vault via Service Principal, authentication credentials need
to be available to the node. Since it's bad practice to store credentials in code (such as directly in an attribute, or recipe), I suggest either:
* Storing the secret in a Chef encrypted data bag
* Storing the secret in a protected file much like the Chef `encrypted_data_bag_secret` file used to access Chef encrypted data bags.

# Helpers

## akv_vault_secret

This helper will allow you to retrieve a secret from an azure keyvault.

### Using SPN:
```ruby
spn = {
  'tenant_id' => '11e34-your-tenant-id-1232',
  'client_id' => '11e34-your-client-id-1232',
  'secret' => 'your-client-secret'
}

# Write the secret to a file:
file '/etc/config_file' do
  content lazy { "password = #{akv_get_secret(vault: <vault_name>, secret: <secret_name>, spn: spn)}" }
end
```

### Using system-assigned Managed Identity:
If you don't provide an spn, `akv_get_secret` will assume you're using an Managed Service Identity.
```ruby
# Write the secret to a file:
file '/etc/config_file' do
  content lazy { "password = #{akv_get_secret(vault: <vault_name>, secret: <secret_name>)}" }
end
```

### Using user-assigned Managed Identity:
When using a user-assigned Managed Identity only one of `client_id`, `object_id` or `msi_res_id` must be provided.

```ruby
user_assigned_msi = {
  'client_id' => '11e34-your-client-id-1232'
}
# user_assigned_msi = {
#   'object_id' => '11e34-your-object-id-1232'
# }
# user_assigned_msi = {
#   'msi_res_id' => '11e34-your-msi-res-id-1232'
# }

# Write the secret to a file:
file '/etc/config_file' do
  content lazy { "password = #{akv_get_secret(vault: <vault_name>, secret: <secret_name>, user_assigned_msi: user_assigned_msi)}" }
end
```



License and Author
==================

* Author:: Jeff Mendoza (<jemendoz@microsoft.com>)
* Author:: Andre Elizondo (<andre@chef.io>)
* Author:: Kris Zentner (<krisz@microsoft.com>)

Copyright (c) Microsoft Open Technologies, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
