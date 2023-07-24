# Create a CodePipeline
resource "aws_codepipeline" "my_pipeline" {
  name     = "MyPipeline" # Replace with your desired pipeline name
  role_arn = aws_iam_role.codepipeline_role.arn

    artifact_store {
    location = aws_s3_bucket.artifacts_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = aws_codecommit_repository.my_repo.repository_name
        BranchName     = "master" # Replace with your desired branch name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "ElasticBeanstalkDeploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration = {
        ApplicationName = aws_elastic_beanstalk_application.my_app.name
        EnvironmentName = aws_elastic_beanstalk_environment.my_env.name
      }
    }
  }
}


resource "aws_s3_bucket" "artifacts_bucket" {
  bucket = "my-example-artifacts" # Replace with your desired S3 bucket name
    acl = "private" # Adjust the bucket ACL as needed
}
