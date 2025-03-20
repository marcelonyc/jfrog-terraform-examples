## WebGoat repos
Configure Artifactory repositories to align with the WebGoat demo requirments

## Setup
- Install terraform cli
- Inititalize your project project
- Include this module
    - example
```json
module "orgs" {
  source = "./orgs"

  // pass in your variables here
}```

- You must define these Environment variable
    - JFROG_ACCESS_TOKEN_CI_INSTANCE (JFrog access token)
    - JFROG_ACCESS_TOKEN_CD_INSTANCE (JFrog access token)
    - JFROG_URL_CI_INSTANCE (CI JFrog instamce *https://...* )
    - JFROG_URL_CD_INSTANCE (CD JFrog instamce *https://...* )
###Example CSV that drives repo creation

|prefix|ci|cd|edge|docker|maven|maven_remote|docker_remote|env|federated|xray_enabled|
|----|----|----|----|----|----|----|----|----|----|----|
|webgoat-jfrog-github|true|true|true|true|true|false|false|dev|true|true|
|webgoat-jfrog-github|true|true|true|true|true|false|false|qa|true|true|
|webgoat-jfrog-github|true|true|true|true|true|false|false|prod|true|true|