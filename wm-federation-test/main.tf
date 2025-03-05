module "orgs" {
  source = "./orgs"

  // pass in your variables here
}



resource "artifactory_federated_maven_repository" "terraform-federated-test-maven-repo" {
  for_each = { for org in local.orgs_list : "${org.org}.${org.maven}.${org.ci}.${org.cd}" => org if org.maven == "true" && org.federated == "true" } 

  provider = artifactory.ci_instance
  key       = "${each.value.org}-maven-dev-repo"
  cleanup_on_delete = true


  dynamic "member" {

    for_each = { for org_member in [ each.value.org ] : each.value.org => org_member if each.value.ci == "true" }

    content {
        url     = "${var.JFROG_URL_CI_INSTANCE}/artifactory/${each.value.org}-maven-dev-repo"
        enabled = true
    }
  
  }
  
  dynamic "member" {

    for_each = { for org in [ each.value.org ]: each.value.org => org if each.value.cd == "true" }

    content {
      url     = "${var.JFROG_URL_CD_INSTANCE}/artifactory/${each.value.org}-maven-dev-repo"
      enabled = true
    }
  }

}

resource "artifactory_local_maven_repository" "mvn-local-ci" {
  provider = artifactory.ci_instance
  for_each = { for org in local.orgs_list : "${org.org}.${org.maven}.${org.ci}.${org.cd}" => org if org.maven == "true" && org.federated == "false" } 
  key             = "${each.value.org}-maven-local-ci"
}

resource "artifactory_local_docker_v2_repository" "docker-local-ci" {
  provider = artifactory.ci_instance
  for_each = { for org in local.orgs_list : "${org.org}.${org.maven}.${org.ci}.${org.cd},${org.xray_enabled}" => org if org.docker == "true" && org.federated == "false" } 
  key             = replace("${each.value.org}-docker-dev-repo","_", "-")
  xray_index      = each.value.xray_enabled
}


resource "artifactory_federated_docker_v2_repository" "docker-federated" {
  provider = artifactory.ci_instance
  for_each = { for org in local.orgs_list : "${org.org}.${org.maven}.${org.ci}.${org.cd},${org.xray_enabled}" => org if org.docker == "true" && org.federated == "true" } 
  key             = replace("${each.value.org}-docker-dev-repo","_", "-")
  xray_index      = each.value.xray_enabled

  dynamic "member" {

    for_each = { for org in [ each.value.org ]: each.value.org => org if each.value.cd == "true" }

    content {
      url     = "${var.JFROG_URL_CI_INSTANCE}/artifactory/${replace("${each.value.org}-docker-dev-repo","_", "-")}"
      enabled = true
    }
  }

    dynamic "member" {

    for_each = { for org in [ each.value.org ]: each.value.org => org if each.value.cd == "true" }

    content {
      url     = "${var.JFROG_URL_CD_INSTANCE}/artifactory/${replace("${each.value.org}-docker-dev-repo","_", "-")}"
      enabled = true
    }
  }

}