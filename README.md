# GoLinks

Creates a shortlinking service in AWS.

Stack is:
- API Gateway
- Lambda (Python 3.8)
- Dynamo DB

as well as whatever IAM roles are needed to permission the above services to talk to each other.

### Prerequisites

You must already have a certificate issued by [ACM](https://aws.amazon.com/certificate-manager/) for the domain you wish to use.
