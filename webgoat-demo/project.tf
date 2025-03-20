locals {
  project_meta = jsondecode(file("${path.module}/project.json"))
}

