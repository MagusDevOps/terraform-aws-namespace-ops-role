data "aws_iam_policy_document" "deny_other_namespaces_policy_document" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "StringNotEqualsIgnoreCaseIfExists"
      values   = "${local.prefix}"
      variable = "aws:RequestTag/${var.prefix_tag_key}"
    }

    condition {
      test     = "StringNotEqualsIgnoreCaseIfExists"
      values   = "${var.namespace}"
      variable = "aws:RequestTag/${var.namespace_tag_key}"
    }

    condition {
      test     = "StringNotEqualsIgnoreCaseIfExists"
      values   = "${local.prefix}"
      variable = "aws:ResourceTag/${var.prefix_tag_key}"
    }

    condition {
      test     = "StringNotEqualsIgnoreCaseIfExists"
      values   = "${var.namespace}"
      variable = "aws:ResourceTag/${var.namespace_tag_key}"
    }
  }
}

resource "aws_iam_policy" "deny_other_namespaces_policy" {
  name   = "${local.prefix}-${var.namespace}-devops-deny-other"
  path   = "${local.policy_path}"
  policy = "${data.aws_iam_policy_document.deny_other_namespaces_policy_document.json}"
}
