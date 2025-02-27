terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
      version = "12.3.3"
    }
  }
  backend "remote" {
        hostname = "mdlone.jfrog.io"
        organization = "tf-repo-manager-be"
        workspaces {
            name = "wm-my-tf-be-ws"
        }
    }
}


provider "artifactory" {
  alias = "primary"
  access_token = var.JFROG_ACCESS_TOKEN_PRIMARY
  url = var.JFROG_URL_PRIMARY
}

provider "artifactory" {
  alias = "secondary"
  access_token = var.JFROG_ACCESS_TOKEN_SECONDARY
  url = var.JFROG_URL_SECONDARY
}

provider "artifactory" {
  alias = "edge"
  access_token = var.JFROG_ACCESS_TOKEN_EDGE
  url = var.JFROG_URL_EDGE
}

provider "artifactory" {
  alias = "soleng"
  access_token = var.JFROG_ACCESS_TOKEN_SOLENG
  url = var.JFROG_URL_SOLENG
}