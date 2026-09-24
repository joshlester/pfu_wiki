
## Transfer files to server
```
rsync -avzP -e "ssh -i ~/.ssh/eltirus_enable_vm_01.prv" /mnt/c/Users/JoshLester/projects/enable-docs/dist/ eltirus_enable_01@20.211.108.35:/srv/www/enable-docs/0.1.0
```

## Commands to give eltirus-enable domain access to enable domain
These were attempts never got the functionality working:
az resource update --resource-type "Microsoft.Web/sites/config" --name <YourWebAppName>/authsettingsV2 --resource-group <YourResourceGroup> --set properties.identityProviders.azureActiveDirectory.validation.tenantRestrictions.allowedTenants="[ 'tenant-id-1', 'tenant-id-2' ]"


az resource update --resource-type "Microsoft.Web/sites/config" --name eltirus-enable/authsettingsV2 --resource-group rg_eltirus_enable --set properties.identityProviders.azureActiveDirectory.validation.tenantRestrictions.allowedTenants="[ '2163e777-fa82-4218-910c-a3f264f7bcc9', 'd9e1e161-c5a6-4a39-9716-4cf038c3dd4e' ]"

az resource update --resource-type "Microsoft.Web/sites/config" --name eltirus-enable/authsettingsV2 --resource-group rg_eltirus_enable --set properties.identityProviders.azureActiveDirectory.validation.tenantRestrictions.allowedTenants="['2163e777-fa82-4218-910c-a3f264f7bcc9','d9e1e161-c5a6-4a39-9716-4cf038c3dd4e']"

az webapp auth config-version show --name eltirus-enable --resource-group rg_eltirus_enable

az resource show --resource-type "Microsoft.Web/sites/config" --name eltirus-enable/authsettingsV2 --resource-group rg_eltirus_enable --query properties.identityProviders.azureActiveDirectory.validation.tenantRestrictions.allowedTenants

az webapp auth show --name eltirus-enable --resource-group rg_eltirus_enable


az webapp auth update --name <web_app_name> --resource-group <resource_group_name> --set identityProviders.azureActiveDirectory.validation.tenantRestrictions.allowedTenants="['<tenant-id-1>','<tenant-id-2>']"
az webapp auth update --name eltirus-enable --resource-group rg_eltirus_enable --set identityProviders.azureActiveDirectory.validation.tenantRestrictions.allowedTenants="['2163e777-fa82-4218-910c-a3f264f7bcc9','d9e1e161-c5a6-4a39-9716-4cf038c3dd4e']"


az webapp auth show --name eltirus-enable --resource-group rg_eltirus_enable --query "identityProviders.azureActiveDirectory.validation.tenantRestrictions.allowedTenants"

az resource show --ids /subscriptions/<subscription-id>/resourceGroups/<YourResourceGroup>/providers/Microsoft.Web/sites/<YourWebAppName>/config/authsettingsV2

az resource show --ids /subscriptions/5e54fa34-4241-4f7f-9ba8-9c546f465a80/resourceGroups/rg_eltirus_enable/providers/Microsoft.Web/sites/eltirus-enable/config/authsettingsV2

