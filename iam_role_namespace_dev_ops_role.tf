data "aws_iam_policy_document" "devops_role_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "namespace_devops_role" {
  name               = "${local.prefix}-${local.namespace}-devops-role"
  assume_role_policy = "${data.aws_iam_policy_document.devops_role_document.json}"
  tags               = "${local.tags}"
}

resource "aws_iam_role_policy_attachment" "attach_system_administrator" {
  policy_arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
  role       = "${aws_iam_role.namespace_devops_role.name}"
}

resource "aws_iam_role_policy_attachment" "attach_database_administrator" {
  policy_arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
  role       = "${aws_iam_role.namespace_devops_role.name}"
}

resource "aws_iam_role_policy_attachment" "attach_aws_admin_access_to_devops_role" {
  policy_arn = "${aws_iam_policy.deny_other_namespaces_policy.arn}"
  role       = "${aws_iam_role.namespace_devops_role.name}"
}
