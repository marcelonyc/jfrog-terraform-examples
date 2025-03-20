resource "artifactory_federated_maven_repository" "terraform-federated-test-maven-repo" {
  for_each = { for prefix in local.prefixs_list : "${prefix.prefix}.${prefix.maven}.${prefix.ci}.${prefix.cd}.${prefix.env}" => prefix if prefix.maven == "true" && prefix.federated == "true" } 

  provider = artifactory.ci_instance
  key       = "${each.value.prefix}-maven-local-${each.value.env}"
  cleanup_on_delete = true
  project_environments = [ upper(each.value.env) ]

  dynamic "member" {

    for_each = { for prefix_member in [ each.value.prefix ] : each.value.prefix => prefix_member if each.value.ci == "true" }

    content {
        url     = "${var.JFROG_URL_CI_INSTANCE}/artifactory/${each.value.prefix}-maven-local-${each.value.env}"
        enabled = true
    }
  
  }
  
  dynamic "member" {

    for_each = { for prefix in [ each.value.prefix ]: each.value.prefix => prefix if each.value.cd == "true" }

    content {
      url     = "${var.JFROG_URL_CD_INSTANCE}/artifactory/${each.value.prefix}-maven-local-${each.value.env}"
      enabled = true
    }
  }

}

resource "artifactory_local_maven_repository" "mvn-local-ci" {
  provider = artifactory.ci_instance
  for_each = { for prefix in local.prefixs_list : "${prefix.prefix}.${prefix.maven}.${prefix.ci}.${prefix.cd}" => prefix if prefix.maven == "true" && prefix.federated == "false" } 
  key             = "${each.value.prefix}-maven-local-ci"
}


resource "artifactory_remote_maven_repository" "maven-remote-ci" {
  provider = artifactory.ci_instance
  for_each = { for prefix in local.prefixs_list : "${prefix.prefix}.${prefix.maven}.${prefix.ci}.${prefix.cd}" => prefix if prefix.maven_remote == "true" } 
  key             = "${each.value.prefix}-maven-remote"
  url                             = "https://repo1.maven.org/maven2/"
  fetch_jars_eagerly              = true
  fetch_sources_eagerly           = false
  suppress_pom_consistency_checks = false
  reject_invalid_jars             = true
  metadata_retrieval_timeout_secs = 120
  max_unique_snapshots            = 10
}

resource "artifactory_remote_maven_repository" "maven-remote-cd" {
  provider = artifactory.cd_instance
  for_each = { for prefix in local.prefixs_list : "${prefix.prefix}.${prefix.maven}.${prefix.ci}.${prefix.cd}" => prefix if prefix.maven_remote == "true" } 
  key             = "${each.value.prefix}-maven-remote"
  url                             = "https://repo1.maven.org/maven2/"
  fetch_jars_eagerly              = true
  fetch_sources_eagerly           = false
  suppress_pom_consistency_checks = false
  reject_invalid_jars             = true
  metadata_retrieval_timeout_secs = 120
  max_unique_snapshots            = 10
}


resource "artifactory_local_docker_v2_repository" "docker-local-ci" {
  provider = artifactory.ci_instance
  for_each = { for prefix in local.prefixs_list : "${prefix.prefix}.${prefix.maven}.${prefix.ci}.${prefix.cd},${prefix.xray_enabled}" => prefix if prefix.docker == "true" && prefix.federated == "false" } 
  key             = replace("${each.value.prefix}-docker-dev","_", "-")
  xray_index      = each.value.xray_enabled
  project_environments = [ upper(each.value.env) ]

}


resource "artifactory_remote_docker_repository" "docker-remote-ci" {
  provider = artifactory.ci_instance
  for_each = { for prefix in local.prefixs_list : "${prefix.prefix}.${prefix.docker_remote}.${prefix.ci}.${prefix.cd},${prefix.xray_enabled}.${prefix.env}" => prefix if prefix.docker_remote == "true" } 

  key                            = "${each.value.prefix}-docker-remote"
  external_dependencies_enabled  = true
  external_dependencies_patterns = ["**/registry-1.docker.io/**"]
  enable_token_authentication    = true
  url                            = "https://registry-1.docker.io/"
  block_pushing_schema1          = true
}

resource "artifactory_remote_docker_repository" "docker-remote-cd" {
  provider = artifactory.cd_instance
  for_each = { for prefix in local.prefixs_list : "${prefix.prefix}.${prefix.docker_remote}.${prefix.ci}.${prefix.cd},${prefix.xray_enabled}.${prefix.env}" => prefix if prefix.docker_remote == "true"  } 

  key                            = "${each.value.prefix}-docker-remote"
  external_dependencies_enabled  = true
  external_dependencies_patterns = ["**/registry-1.docker.io/**"]
  enable_token_authentication    = true
  url                            = "https://registry-1.docker.io/"
  block_pushing_schema1          = true
}

resource "artifactory_federated_docker_v2_repository" "docker-federated" {
  provider = artifactory.ci_instance
  for_each = { for prefix in local.prefixs_list : "${prefix.prefix}.${prefix.maven}.${prefix.ci}.${prefix.cd},${prefix.xray_enabled}.${prefix.env}" => prefix if prefix.docker == "true" && prefix.federated == "true" } 
  key             = replace("${each.value.prefix}-docker-local-${each.value.env}","_", "-")
  xray_index      = each.value.xray_enabled
  project_environments = [ upper(each.value.env) ] 


  dynamic "member" {

    for_each = { for prefix in [ each.value.prefix ]: each.value.prefix => prefix if each.value.cd == "true" }

    content {
      url     = "${var.JFROG_URL_CI_INSTANCE}/artifactory/${replace("${each.value.prefix}-docker-local-${each.value.env}","_", "-")}"
      enabled = true
    }
  }

  dynamic "member" {

    for_each = { for prefix in [ each.value.prefix ]: each.value.prefix => prefix if each.value.cd == "true" }

    content {
      url     = "${var.JFROG_URL_CD_INSTANCE}/artifactory/${replace("${each.value.prefix}-docker-local-${each.value.env}","_", "-")}"
      enabled = true
    }
  }
  depends_on = [artifactory_federated_maven_repository.terraform-federated-test-maven-repo]
}