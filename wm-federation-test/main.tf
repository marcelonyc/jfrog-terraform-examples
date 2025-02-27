resource "artifactory_federated_maven_repository" "terraform-federated-test-maven-repo" {
  provider = artifactory.primary
  key       = "maven-dev-repo"
  cleanup_on_delete = true

  member {
    url     = "${var.JFROG_URL_PRIMARY}/artifactory/maven-dev-repo"
    enabled = true
  }

  member {
    url     = "${var.JFROG_URL_SECONDARY}/artifactory/maven-dev-repo"
    enabled = true

  }

  member {
    url     = "${var.JFROG_URL_SOLENG}/artifactory/maven-dev-repo"
    access_token = var.JFROG_ACCESS_TOKEN_SOLENG
    enabled = true
  }
}