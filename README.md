# TerraOak - Finding Design Gaps Daily
![TerraOak](oak9-logo.png)

TerraOak is Oak9's vulnerable IAC code repo.   This repo will be used for learning and training purposes on how to implement a cloud security posture. 

## Table of Contents

* [Introduction](#introduction)
* [Blast Off](#Getting-Started-Terraform-Code-Execution)


## Introduction 

Before you proceed, WARNING:
> :warning: TerraOak is a test repo for creating Vulnerable resources, please use at your own discrention, Oak9 is not responsible for any damages. **DO NOT deploy TerraOak in a production environment or any AWS accounts that contain sensitive information.**

TerraOak is a public repo available to the general audience to showcase the Oak9 cli in action.  It can be used to test our cli against our dynamic blueprint engine to validate design gaps.

## Scenario

Lets Build a Users API using the below resources and secure using Oak9. 

* s3
* dyanmodb
* api-gateway
* lambda 

## Terraform Code 

The code in this repo should not be run inside of your company's aws accounts but rather in a playground account.   

## Running it inside of a docker container

* pull image from docker hum docker pull oak9/cli
* pass following env vars to the container 
    * OAK9_API_KEY
    * OAK9_PROJECT_ID
    * OAK9_DIR = "directory of your terraform code"

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |


* Ensure your create your backend bucket and table for terraform state file. This config will need to reside in a .tf file in the root directory. 

https://www.terraform.io/language/settings/backends/s3

## Getting Started Terraform Code Execution

* Download github code locally 
* Ensure requirements are met 
* Run terraform init 
* Run terraform plan/apply 
* Add a api user with following command 

`curl -X POST "$(terraform output -raw base_url)/set-user?id=0&name=john&orgid=xyx&plan=enterprise&orgname=xyzdfd&creationdate=82322"`

* Retrieve an api user 

`curl "$(terraform output -raw base_url)/get-user?id=0"`
 

## Getting Started Oak9 CLI Execution 

Downloading the TerraOak Cli and the instructions on how to run it can be found here, https://docs.oak9.io/oak9/fundamentals/integrations/cli-integration

