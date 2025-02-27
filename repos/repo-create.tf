# Required for Terraform 1.0 and up (https://www.terraform.io/upgrade-guides)
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
            name = "my-tf-be-ws"
        }
    }
}
variable "JFROG_ACCESS_TOKEN_PRIMARY" {
  type = string
}
variable "JFROG_ACCESS_TOKEN_SECONDARY" {
  type = string
}
variable "JFROG_ACCESS_TOKEN_EDGE" {
  type = string
}

variable "JFROG_URL_PRIMARY" {
  type = string
}

variable "JFROG_URL_SECONDARY" {
  type = string
}

variable "JFROG_URL_EDGE" {
  type = string
}



provider "artifactory" {
  alias = "primary"
  access_token = var.JFROG_ACCESS_TOKEN_PRIMARY
  url = var.JFROG_URL_PRIMARY
  // supply JFROG_ACCESS_TOKEN, and JFROG_URL as env vars
}

provider "artifactory" {
  alias = "secondary"
  access_token = var.JFROG_ACCESS_TOKEN_SECONDARY
  url = var.JFROG_URL_SECONDARY
  // supply JFROG_ACCESS_TOKEN, and JFROG_URL as env vars
}

provider "artifactory" {
  alias = "edge"
  access_token = var.JFROG_ACCESS_TOKEN_EDGE
  url = var.JFROG_URL_EDGE
  // supply JFROG_ACCESS_TOKEN, and JFROG_URL as env vars
}


locals {
  envs = ["DEV", "QA", "PROD"]
  repos = ["maven", "docker"]
  all_repos = distinct(flatten([
    for env in local.envs : [
      for repo in local.repos : {
        env    = env
        type = repo
        key = lower("${repo}-${env}")
      }
    ]
  ]))
}

resource "artifactory_local_maven_repository" "mvn-local" {
  provider = artifactory.primary
  for_each      = { for entry in local.all_repos: "${entry.env}.${entry.type}.${entry.key}" => entry if entry.type == "maven" }
  key             = each.value.key
  project_environments     = [each.value.env]

}

resource "artifactory_local_docker_v2_repository" "docker-local-primary" {
  provider = artifactory.primary
  for_each      = { for entry in local.all_repos: "${entry.env}.${entry.type}.${entry.key}" => entry if entry.type == "docker" }
  key             = each.value.key
  xray_index      = false
  project_environments     = [each.value.env]
}


resource "artifactory_local_docker_v2_repository" "docker-local-secondary" {
  provider = artifactory.secondary
  for_each      = { for entry in local.all_repos: "${entry.env}.${entry.type}.${entry.key}" => entry if entry.type == "docker" }
  key             = each.value.key
  project_environments     = [each.value.env]
  depends_on = [artifactory_local_docker_v2_repository.docker-local-primary]

}