output "cluster_arn" {
    value = aws_iam_role.this.arn
}

output "cluster_name" {
    value = aws_iam_role.this.name
}