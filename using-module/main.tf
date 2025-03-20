terraform {
  backend "remote" {
        hostname = "mdlone.jfrog.io"
        organization = "tf-repo-manager-be"
        workspaces {
            name = "example-tf-module-ws"
        }
    }
}
module "demo-module" {
  source = "mdlone.jfrog.io/tf-repo-manager-module__jfrog/soleng/demorepos"
  version = "v1.0"
  JFROG_ACCESS_TOKEN_CD_INSTANCE = var.JFROG_ACCESS_TOKEN_CD_INSTANCE
  JFROG_ACCESS_TOKEN_CI_INSTANCE = var.JFROG_ACCESS_TOKEN_CI_INSTANCE
  JFROG_ACCESS_TOKEN_EDGE = var.JFROG_ACCESS_TOKEN_EDGE
  JFROG_URL_CD_INSTANCE = var.JFROG_URL_CD_INSTANCE
  JFROG_URL_CI_INSTANCE = var.JFROG_URL_CI_INSTANCE
  JFROG_URL_EDGE = var.JFROG_URL_EDGE
  REPO_LIST_FILE = var.REPO_LIST_FILE

  
} 
