
# Create an Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "my_app" {
  name        = "MyEBAApplication" # Replace with your desired application name
  description = "My Elastic Beanstalk Application"
}

# Create an Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "my_env" {
  name                = "MyEBAEnvironment" # Replace with your desired environment name
  application         = aws_elastic_beanstalk_application.my_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.8.2 running Node.js 18" # Change to your desired stack

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "S3_BUCKET_NAME"
    value     = "my-pipeline-artifact-bucket"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.instance_profile.name
  }
}