# Required for Terraform 1.0 and up (https://www.terraform.io/upgrade-guides)
terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
      version = "12.3.3"
    }
  }
}
variable "JFROG_ACCESS_TOKEN_SOLENG" {
  type = string
}


variable "JFROG_URL_SOLENG" {
  type = string
}




provider "artifactory" {
  alias = "soleng"
  access_token = var.JFROG_ACCESS_TOKEN_SOLENG
  url = var.JFROG_URL_SOLENG
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
        key = lower("marcelo-tf-test-${repo}-${env}")
      }
    ]
  ]))
}

resource "artifactory_local_maven_repository" "mvn-local" {
  provider = artifactory.soleng
  for_each      = { for entry in local.all_repos: "${entry.env}.${entry.type}.${entry.key}" => entry if entry.type == "maven" }
  key             = each.value.key
  project_environments     = [each.value.env]

}

