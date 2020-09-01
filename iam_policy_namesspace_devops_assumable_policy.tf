data "aws_iam_policy_document" "namespace_devops_role_assumable_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEqualsIgnoreCase"
      values   = ["${local.namespace}"]
      variable = "iam:ResourceTag/${var.namespace_tag_key}"
    }

    condition {
      test     = "StringEqualsIgnoreCase"
      values   = ["${var.prefix}"]
      variable = "iam:ResourceTag/${var.prefix_tag_key}"
    }

    condition {
      test     = "StringEqualsIgnoreCase"
      values   = ["&{aws:username}"]
      variable = "sts:RolesSessionName"
    }
  }

  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "NotIpAddressIfExists"
      values   = "${var.cidr_restrictions}"
      variable = "aws:SourceIp"
    }

    condition {
      test     = "BoolIfExists"
      values   = ["false"]
      variable = "aws:ViaAWSService"
    }
  }
}

resource "aws_iam_policy" "devops_role_assumable_policy" {
  name   = "${local.prefix}-${local.namespace}-devops-assumable-role"
  path   = "${local.policy_path}"
  policy = "${data.aws_iam_policy_document.namespace_devops_role_assumable_document.json}"
}
