# AWS Gameday Networking

Terraform for the migration GameDay scenario VPC network.

Creates a VPC across 2 Availability Zones, with 1 public and 2 private subnets
in each.

## Usage

To deploy the VPC, simply run the following commands with valid AWS credentials
set on the command line:

```console
$ terraform init
$ terraform apply
```

You may override the region or subnet variables by passing parameters like
`--var 'region=us-east-1'`
