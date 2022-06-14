
output "name" {
  description = "The name of the module"
  value       = local.name
  depends_on  = [null_resource.setup_gitops]
}

output "branch" {
  description = "The branch where the module config has been placed"
  value       = local.application_branch
  depends_on  = [null_resource.setup_gitops]
}

output "namespace" {
  description = "The namespace where the secret will be deployed"
  value       = local.namespace
  depends_on  = [null_resource.setup_gitops]
}

output "server_name" {
  description = "The server where the module will be deployed"
  value       = var.server_name
  depends_on  = [null_resource.setup_gitops]
}

output "layer" {
  description = "The layer where the module is deployed"
  value       = local.layer
  depends_on  = [null_resource.setup_gitops]
}

output "type" {
  description = "The type of module where the module is deployed"
  value       = local.type
  depends_on  = [null_resource.setup_gitops]
}

output "secret_name" {
  description = "The name of the secret that was created"
  value       = local.secret_name
  depends_on = [null_resource.setup_gitops]
}

output "host_key" {
  description = "The key in the secret that holds the host information"
  value       = local.host_key
  depends_on = [null_resource.setup_gitops]
}

output "port_key" {
  description = "The key in the secret that holds the port information"
  value       = local.port_key
  depends_on = [null_resource.setup_gitops]
}

output "database_key" {
  description = "The key in the secret that holds the database name information"
  value       = local.database_key
  depends_on = [null_resource.setup_gitops]
}

output "username_key" {
  description = "The key in the secret that holds the username information"
  value       = local.username_key
  depends_on = [null_resource.setup_gitops]
}

output "password_key" {
  description = "The key in the secret that holds the password information"
  value       = local.password_key
  depends_on = [null_resource.setup_gitops]
}
