# GoLinks

Creates a shortlinking service in AWS.

Stack is:
- API Gateway
- Lambda (Python 3.8)
- Dynamo DB

as well as whatever IAM roles are needed to permission the above services to talk to each other.

### How to use

Modify `pylib/config.json` with the domain name of the domain you wish to use and the name of the table to set up in DynamoDB. Both the .tf and .py scripts read this config. From there, it's as simple as logging into your AWS account and running `terraform init && terraform apply` from the root folder of this repository.

### Prerequisites

You must already have a certificate issued by [ACM](https://aws.amazon.com/certificate-manager/) for the domain you wish to use.
