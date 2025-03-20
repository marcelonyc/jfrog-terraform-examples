terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
      version = "12.9.1"
    }
  }
  backend "remote" {
        hostname = "mdlone.jfrog.io"
        organization = "tf-repo-manager-be"
        workspaces {
            name = "webgoat-my-tf-be-ws"
        }
    }
}


provider "artifactory" {
  alias = "ci_instance"
  access_token = var.JFROG_ACCESS_TOKEN_CI_INSTANCE
  url = var.JFROG_URL_CI_INSTANCE
}

provider "artifactory" {
  alias = "cd_instance"
  access_token = var.JFROG_ACCESS_TOKEN_CD_INSTANCE
  url = var.JFROG_URL_CD_INSTANCE
}

provider "artifactory" {
  alias = "edge"
  access_token = var.JFROG_ACCESS_TOKEN_EDGE
  url = var.JFROG_URL_EDGE
}
