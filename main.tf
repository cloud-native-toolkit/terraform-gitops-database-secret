locals {
  name          = "database-secret"
  bin_dir       = module.setup_clis.bin_dir
  secrets_dir   = "${path.cwd}/.tmp/${local.name}/secrets"
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/sealed-secrets"
  secret_name   = var.secret_name
  host_key      = "host"
  port_key      = "port"
  database_key  = "database"
  username_key  = "username"
  password_key  = "password"
  layer = "infrastructure"
  type  = "base"
  application_branch = "main"
  namespace = var.namespace
  layer_config = var.gitops_config[local.layer]
}

module setup_clis {
  source = "cloud-native-toolkit/clis/util"
  version = "1.16.1"

  clis = ["kubectl"]
}

resource null_resource create_secrets_yaml {

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-secrets.sh '${var.namespace}' '${local.secret_name}' '${local.secrets_dir}'"

    environment = {
      BIN_DIR = module.setup_clis.bin_dir
      DATABASE_PASSWORD = var.database_password
      DATABASE_USERNAME = var.database_username
      DATABASE_HOST = var.database_host
      DATABASE_PORT = var.database_port
      DATABASE_NAME = var.database_name
      HOST_KEY = local.host_key
      PORT_KEY = local.port_key
      DATABASE_NAME_KEY = local.database_key
      USERNAME_KEY = local.username_key
      PASSWORD_KEY = local.password_key
    }
  }
}

module seal_secrets {
  depends_on = [null_resource.create_secrets_yaml]

  source = "github.com/cloud-native-toolkit/terraform-util-seal-secrets.git"

  source_dir    = local.secrets_dir
  dest_dir      = local.yaml_dir
  kubeseal_cert = var.kubeseal_cert
  label         = local.secret_name
}

resource null_resource setup_gitops {
  depends_on = [module.seal_secrets]

  triggers = {
    name = local.name
    namespace = var.namespace
    yaml_dir = local.yaml_dir
    server_name = var.server_name
    layer = local.layer
    type = local.type
    git_credentials = yamlencode(var.git_credentials)
    gitops_config   = yamlencode(var.gitops_config)
    bin_dir = local.bin_dir
  }

  provisioner "local-exec" {
    command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
      GITOPS_CONFIG   = self.triggers.gitops_config
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --delete --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
      GITOPS_CONFIG   = self.triggers.gitops_config
    }
  }
}
