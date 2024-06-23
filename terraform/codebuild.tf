resource "aws_s3_bucket" "codebuild_dev_artifact"{
  bucket = "codebuild-dev-artifacts-s3bucket-siddhesh"
}

resource "aws_s3_bucket" "codebuild_prod_artifacts" {
  bucket = "codebuild-prod-artifacts-s3bucket-siddhesh"
}

resource "aws_iam_role" "codebuild_role"{
  name = "codebuild_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_codebuild_project" "codebuild_dev" {
  name = "codebuild_dev"
  description = "Codebuild project for development environment"
  build_timeout = "5"
  service_role = aws_iam_role.codebuild_role.arn

  source{
    type = "CODECOMMIT"
    location = aws_codecommit_repository.cicd_repository.clone_url_http
    buildspec = "buildspec-dev.yml"
  }

  artifacts {
    type = "S3"
    location = aws_s3_bucket.codebuild_dev_artifact.bucket
    packaging = "ZIP"
    path = "dev-artifacts/"
    namespace_type = "BUILD_ID"
  }
    environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  tags = {
    Name = "my_dev_build"
  }
}

resource "aws_codebuild_project" "codebuild_prod" {
  name = "codebuild_prod"
  description = "Codebuild project for development environment"
  build_timeout = "5"
  service_role = aws_iam_role.codebuild_role.arn

  source{
    type = "CODECOMMIT"
    location = aws_codecommit_repository.cicd_repository.clone_url_http
    buildspec = "buildspec-prod.yml"
  }

  artifacts {
    type = "S3"
    location = aws_s3_bucket.codebuild_prod_artifacts.bucket
    packaging = "ZIP"
    path = "prod-artifacts/"
    namespace_type = "BUILD_ID"
  }
    environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  tags = {
    Name = "my_prod_build"
  }
}



