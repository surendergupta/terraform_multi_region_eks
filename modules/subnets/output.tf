# output "subnet_ids" {
#   value = [for subnet in aws_subnet.this : subnet.id]
# }

output "subnet_ids" {
  value = aws_subnet.this[*].id
}