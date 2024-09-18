output "postgres_credentials" {
  value = <<EOF
    # To connect to the database 
    # connect to the first aks cluster 
    # and create psql client in a pod
    az aks get-credentials --resource-group ${var.rg_name} --name ${var.aks_name}
    kubectl create ns app1
    kubectl config set-context --current --namespace=app1
    kubectl run --image postgres:16.4 pg -- tail -f /dev/null
    kubectl exec -it pg -- bash 
    export PGHOST=${var.postgres_server_name}.postgres.database.azure.com
    export PGUSER=${var.admin_username}
    export PGPORT=5432
    export PGDATABASE=postgres
    export PGPASSWORD='${random_password.postgres_password.result}'
    psql
    # To access the replica change 
    # export PGHOST=replica-${var.postgres_server_name}.postgres.database.azure.com
    EOF
}