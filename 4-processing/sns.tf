# Create IAM role
resource "aws_iam_role" "sns-iam-role" {
  name               = "SNS-IAM-Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["sns.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

# Attach Policies to IAM Role
resource "aws_iam_role_policy_attachment" "ec2-role-policy-attach" {
  count      = length(var.sns_policies)
  policy_arn = element(var.sns_policies, count.index)
  role       = aws_iam_role.sns-iam-role.name
}

# Create SNS Topic
resource "aws_sns_topic" "check-schema-lambda-update" {
  name                                  = "check-schema-lambda-update"
  application_success_feedback_role_arn = aws_iam_role.sns-iam-role.arn
  application_failure_feedback_role_arn = aws_iam_role.sns-iam-role.arn
}