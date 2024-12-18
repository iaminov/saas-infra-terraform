resource "aws_codebuild_project" "terraform" {
  name         = "${var.project}-cb"
  service_role = var.codebuild_service_role_arn
  artifacts { type = "NO_ARTIFACTS" }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    environment_variable {
      name  = "TF_IN_AUTOMATION"
      value = "true"
    }
  }
  source {
    type            = "GITHUB"
    location        = var.github_repo_url
    git_clone_depth = 1
    buildspec       = var.buildspec
  }
}

resource "aws_codepipeline" "terraform" {
  name     = "${var.project}-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    type     = "S3"
    location = var.artifact_bucket
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        Owner  = var.github_owner
        Repo   = var.github_repo
        Branch = var.github_branch
        OAuthToken = var.github_oauth_token
      }
    }
  }

  stage {
    name = "Build"
    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        ProjectName = aws_codebuild_project.terraform.name
      }
    }
  }
}
