resource random_password db_password {
  length = 10
}

module "gitops_module" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  kubeseal_cert = module.gitops.sealed_secrets_cert

  database_host = "myhost.com"
  database_port = "50001"
  database_name = "mydb"
  database_username = "db2inst1"
  database_password = random_password.db_password.result
}
