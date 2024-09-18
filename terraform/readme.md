# Goal 

This is a flexible server module : 
- Create flexible server and a read replica in a subnet inside the same Vnet of the AKS cluster 
- Attach a private DNS zone to the subnet 

# Activate the module 

in your var file `azure/stage_1_aks/tfvars/<first_name>.<last_name>.tfvars` change 
```
enable_flexible_server=true
```
In the module section and apply 

# Obtain the credentials and instruction to connect

```
echo -e $(terraform output -json credentials_flexible_server)
```

# Backing up fexible server database 

This is covered in this [github repo](https://github.com/michaelcourcy/kasten-flexible-server) 
