# TerraOak - Finding Design Gaps Daily
![TerraOak](oak9-logo.png)

TerraOak is Oak9's vulnerable IAC code repo.   This repo will be used for learning and training purposes on how to implement a cloud security posture. 

## Table of Contents

* [Introduction](#introduction)
* [Blast Off](#getting-started)


## Introduction 

Before you proceed, WARNING:
> :warning: TerraOak is a test repo for creating Vulnerable resources, please use at your own discrention, Oak9 is not responsible for any damages. **DO NOT deploy TerraGoat in a production environment or any AWS accounts that contain sensitive information.**

TerraOak is a public repo available to the general audience to showcase the Oak9 cli in action.  It can be used to test our dynamic blueprint engine to show validate terraform code for design gap security issues.

## Scenario

Lets Build a petstore API using the below resources for a fintech company and a health based company. 

* s3
* dyanmodb
* api-gateway
* lambda 

How do we stay secure during the SDLC. 
How do we make sure that our security posture stays consistent when our architecture changes.
What value do we gain for continuous validations and design gaps 

## Getting started

Downloading the TerraOak Cli and the instructions on how to run it can be found here, https://docs.oak9.io/oak9/fundamentals/integrations/cli-integration

## Terraform Code 

The code in this repo should not be run inside of your company's aws accounts but rather in a playground account.   

## Running it inside of a docker container

* pull image from docker hum docker pull oak9/cli
* pass following env vars to the container 
    * OAK9_API_KEY
    * OAK9_PROJECT_ID
    * OAK9_DIR = "directory of your terraform code"

## Prerequisites

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |


## 