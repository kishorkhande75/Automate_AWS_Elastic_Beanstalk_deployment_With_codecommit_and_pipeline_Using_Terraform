
# Create a CodeCommit repository
resource "aws_codecommit_repository" "my_repo" {
  repository_name = "my-repo-name" # Replace with your desired repository name
  description     = "My CodeCommit repository for the project"
}

resource "aws_iam_policy" "codecommit_access_policy" {
  name        = "CodeCommitAccessPolicy"
  description = "Policy to allow CodePipeline to access CodeCommit repository"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:UploadArchive",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:CancelUploadArchive",
        ]
        Resource = aws_codecommit_repository.my_repo.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codecommit_access_attachment" {
  policy_arn = aws_iam_policy.codecommit_access_policy.arn
  role       = aws_iam_role.codepipeline_role.name
}