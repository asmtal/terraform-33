output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_public1_id" {
  value = aws_subnet.public1.id
}

output "subnet_public2_id" {
  value = aws_subnet.public2.id
}

output "subnet_private1_id" {
  value = aws_subnet.private1.id
}

output "subnet_private2_id" {
  value = aws_subnet.private2.id
}

output "route_table_public" {
  value = aws_route_table.public.id
}

output "route_table_private1_id" {
  value = aws_route_table.privat1.id
}

output "route_table_private2_id" {
  value = aws_route_table.privat2.id
}
