provider "aws" {
  region = "eu-west-1"
}

resource "aws_ecr_repository" "base_ecr_repository" {
  name = "base-ecr-repository"
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"
  
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Sid       = ""
      Effect    = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild-policy"
  description = "Policy to push on ${aws_ecr_repository.base_ecr_repository.name} ECR repository"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Effect   = "Allow"
        Resource = [aws_ecr_repository.base_ecr_repository.arn]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "queue_read_policy_attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

data "local_file" "buildspec_local" {
  filename = "../buildspec.yml"
}

resource "aws_codebuild_project" "nodejs_codebuild_project" {
  name          = "nodejs-codebuild-project"
  description   = "nodejs app CodeBuild project"
  build_timeout = 180
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type                = "NO_SOURCE"
    buildspec           = data.local_file.buildspec_local.content
    report_build_status = true
  }
}
