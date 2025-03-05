# JFrog TF example 
This Terraform example uses a CSV file to drive the creation of artifact repositories. The project is under the wm-federation-test

## Repo types define
- Maven
- Docker

## Setup
- Install terraform cli
- Inititalize the project
    - You must be in the in the wm-federation-test
- You must define these Environment variable
    - JFROG_ACCESS_TOKEN_CI_INSTANCE (JFrog access token)
    - JFROG_ACCESS_TOKEN_CD_INSTANCE (JFrog access token)
    - JFROG_URL_CI_INSTANCE (CI JFrog instamce *https://...* )
    - JFROG_URL_CD_INSTANCE (CD JFrog instamce *https://...* )

## Config
The repo creation is driven from the file orgs_config.csv. 
Notes:
- Only Maven and Docker are operational
- Edge Node is nto operational