# Automate_AWS_Elastic_Beanstalk_deployment_With_codecommit_and_pipeline_Using_Terraform

# AWS Elastic Beanstalk Resources

This repository contains Terraform code to provision AWS Elastic Beanstalk resources.

## Prerequisites

- Terraform installed on your local machine
- AWS credentials configured for Terraform

## Usage
1. **Clone this repository for sample code**
    <code>git clone https://github.com/kishorkhande75/sample_code_for_beanstalk_pipeline.git</code>
    <code>cd <em>repository-directory</em> </code>
    Note:- upload the code in codecommit repo as per your codecommit URL
2. **Clone this repository:**

    <code>git clone https://github.com/kishorkhande75/AWS_Elastic_Beanstalk_With_codecommit_and_pipeline_Terraform.git</code>
    
    <code>cd <em>repository-directory</em> </code>

    Update the variables.tf file with your desired configuration.

3. **Initialize the Terraform workspace:**
    - <code>terraform init</code>

4. **Review the plan to see the resources that will be created:**

    - <code>terraform plan</code>

5. **Apply the Terraform configuration to create the resources:**

    - <code>terraform apply</code>

6. **Clean up the resources when no longer needed:**

    - <code>terraform destroy</code>

# Resources
    This Terraform code provisions the following AWS Elastic Beanstalk resources:
    IAM Role: aws-elasticbeanstalk-ec2-role
    IAM Role Policy Attachments:
    AWSElasticBeanstalkWebTier
    AWSElasticBeanstalkWorkerTier
    AWSElasticBeanstalkMulticontainerDocker
    CodeCommitAccessPolicy
    AWSCodePipelineServiceRole-us-east-1-my_pipeline

**Feel free to modify the content and structure to match your specific needs.**