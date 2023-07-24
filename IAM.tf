# create a EC2 Instance profile for beanstalk
resource "aws_iam_role" "elasticbeanstalk_ec2_role" {
  name = "aws-elasticbeanstalk-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "web_tier_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  role       = aws_iam_role.elasticbeanstalk_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "worker_tier_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
  role       = aws_iam_role.elasticbeanstalk_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "multicontainer_docker_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
  role       = aws_iam_role.elasticbeanstalk_ec2_role.name
}

## Attach to Beanstalk EC2 instance Profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "nodejs_instance_profile" # I have change name of instance profile
  role = aws_iam_role.elasticbeanstalk_ec2_role.name
  # Include any other necessary configuration for the instance profile
}

#############################################################################################33

## Create IAM role for codepipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "AWSCodePipelineServiceRole-us-east-1-my_pipeline"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "my_pipeline_policy" {
  name        = "MyCodePipelinePolicy"
  description = "Policy for My CodePipeline"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:PassRole",
        ]
        Resource = "*"
        Effect = "Allow"
        Condition = {
          StringEqualsIfExists = {
            "iam:PassedToService" = [
              "cloudformation.amazonaws.com",
              "elasticbeanstalk.amazonaws.com",
              "ec2.amazonaws.com",
              "ecs-tasks.amazonaws.com",
            ]
          }
        }
      },
      {
        Action = [
          "codecommit:CancelUploadArchive",
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:GetRepository",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:UploadArchive",
        ]
        Resource = "*"
        Effect = "Allow"
      },
      {
        Action = [
          "codedeploy:CreateDeployment",
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:RegisterApplicationRevision",
        ]
        Resource = "*"
        Effect = "Allow"
      },
      {
        Action = [
          "codestar-connections:UseConnection",
        ]
        Resource = "*"
        Effect = "Allow"
      },
      {
        Action = [
          "elasticbeanstalk:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "cloudwatch:*",
          "s3:*",
          "sns:*",
          "cloudformation:*",
          "rds:*",
          "sqs:*",
          "ecs:*",
        ]
        Resource = "*"
        Effect = "Allow"
      },
      {
        Action = [
          "lambda:InvokeFunction",
          "lambda:ListFunctions",
        ]
        Resource = "*"
        Effect = "Allow"
      },
      {
        Action = [
          "opsworks:CreateDeployment",
          "opsworks:DescribeApps",
          "opsworks:DescribeCommands",
          "opsworks:DescribeDeployments",
          "opsworks:DescribeInstances",
          "opsworks:DescribeStacks",
          "opsworks:UpdateApp",
          "opsworks:UpdateStack",
        ]
        Resource = "*"
        Effect = "Allow"
      },
      {
        Action = [
          "cloudformation:CreateStack",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStacks",
          "cloudformation:UpdateStack",
          "cloudformation:CreateChangeSet",
          "cloudformation:DeleteChangeSet",
          "cloudformation:DescribeChangeSet",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:SetStackPolicy",
          "cloudformation:ValidateTemplate",
        ]
        Resource = "*"
        Effect = "Allow"
      },
      {
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuildBatches",
          "codebuild:StartBuildBatch",
        ]
        Resource = "*"
        Effect = "Allow"
      },
      {
        Effect = "Allow"
        Action = [
          "devicefarm:ListProjects",
          "devicefarm:ListDevicePools",
          "devicefarm:GetRun",
          "devicefarm:GetUpload",
          "devicefarm:CreateUpload",
          "devicefarm:ScheduleRun",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "servicecatalog:ListProvisioningArtifacts",
          "servicecatalog:CreateProvisioningArtifact",
          "servicecatalog:DescribeProvisioningArtifact",
          "servicecatalog:DeleteProvisioningArtifact",
          "servicecatalog:UpdateProduct",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudformation:ValidateTemplate",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:DescribeImages",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "states:DescribeExecution",
          "states:DescribeStateMachine",
          "states:StartExecution",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "appconfig:StartDeployment",
          "appconfig:StopDeployment",
          "appconfig:GetDeployment",
        ]
        Resource = "*"
      },
    ]
  })
}
## Attach to IAM role policy to Pipeline
resource "aws_iam_role_policy_attachment" "my_pipeline_role_attachment" {
  policy_arn = aws_iam_policy.my_pipeline_policy.arn
  role       = aws_iam_role.codepipeline_role.name
}


