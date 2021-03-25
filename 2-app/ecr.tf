# Create ECR Repository
resource "aws_ecr_repository" "ecr-repository" {
  name = "sftp_ecr"

  image_scanning_configuration {
    scan_on_push = true
  }
}