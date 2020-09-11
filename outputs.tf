output "grant_assumable_policy_arn" {
  value = "${aws_iam_policy.role_assumable_policy.arn}"
}

output "role_name" {
  value = "${aws_iam_role.namespace_role.name}"
}

output "role_arn" {
  value = "${aws_iam_role.namespace_role.arn}"
}

output "group_name" {
  value = "${aws_iam_group.namespace_group.name}"
}
