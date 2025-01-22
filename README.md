# Create Terraform module

## Scenario

If you have some `Terraform` infrastructure that you want to use more times, you might want to avoid copy-paste with some different values. To do this, you can use `Terraform` modules for some patterns that you have.

## Prerequisites

A Linux or MacOS machine for local development. If you are running Windows, you first need to set up the *Windows Subsystem for Linux (WSL)* environment.

You need `docker cli` and `docker-compose` on your machine for testing purposes, and/or on the machines that run your pipeline.
You can check both of these by running the following commands:
```sh
docker --version
docker-compose --version
```

## Module creation

Inside the `terraform` directory, create a new directory named `modules` and a second directory named `math` inside of it. The idea is to prepare to use more modules in your project. The name of the directories does not matter.

In your `math` module you need some input, some output and something to be done.

Let's create `variables.tf` for the input:
```sh
variable "number1" {
  description = "The first number for calculations"
  type        = number
}

variable "number2" {
  description = "The second number for calculations"
  type        = number
}
```
We will use 2 numbers as input: `number1` and `number2`


Let's create `outputs.tf` for the output:
```sh
output "sum" {
  description = "The sum of the two numbers"
  value       = local.sum
}

output "difference" {
  description = "The difference of the two numbers"
  value       = local.difference
}
```
We will use 2 numbers as output: `sum` and `difference`

Let's create `locals.tf` for the module implementation:
```sh
locals {
  sum        = var.number1 + var.number2
  difference = var.number1 - var.number2
}
```

## Module usage

In the main `Terraform` project we can now use the newly created module:
```sh
module "mathFirst" {
  source  = "./modules/math"

  number1 = 8
  number2 = 3
}
```
Let's use the output of the module as input for a second module call:
```sh
module "mathSecond" {
  source  = "./modules/math"

  number1 = module.mathFirst.sum
  number2 = module.mathFirst.difference
}
```

Since we want to see some numbers when we apply the `Terraform` code, let's add some outputs in `outputs.tf`:
 ```sh
output "mathFirstSum" {
  value = module.mathFirst.sum
}
output "mathFirstDifference" {
  value = module.mathFirst.difference
}

output "mathSecondSum" {
  value = module.mathSecond.sum
}
output "mathSecondDifference" {
  value = module.mathSecond.difference
}
```
When we run the `Terraform` code we will be able to tell whether the results match our expectations.

## Usage

You can now run:
 ```sh
terraform init
terraform apply -auto-approve
```
on your local machine or with the help of a docker container.

In your console you will see something like:
 ```sh
mathFirstDifference = 5
mathFirstSum = 11
mathSecondDifference = 6
mathSecondSum = 16
```
