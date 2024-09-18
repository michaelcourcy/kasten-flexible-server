# Goal

A blueprint for backing up the different databases of a flexible server.

# Prequisite 

Having an AKS cluster or any kubernetes cluster on Azure that connect privately to 
a postgres flexible cluster and his read replica. 
How we build that is beyond the scope of this blueprint guide however I provide 
a terraform module example here. This is just a source of inspiration there is 
no instruction to deploy and operated it.

# Architecture 

TODO 

# How it works 

Each database in the flexible server is mapped to a secret in a namespace that has
the label `database-access=true`. 

A blueprintbinding 
```
todo
```
associate the blueprint `todo.yaml` to the secret. 

Each time the secret is backed up by kasten a `pg_dump` action for this database is operated.

Each time the secret is restored by kasten a `psql < dump-database.sql` is executed for this database.

You can backup and restore your databases on this instance granulary by granulary backup and restore secret
with Kasten.

# Security 

The dump are sent encrypted to the storage account using immutable backup. You are ransomware proof now.

# Migration 

In another tenant the private dns are the same so if the restore is using the same domain it's actually pointing
to another database making your database migration trivial between tenants.


