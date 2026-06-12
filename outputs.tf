output "vpc_id" {
  description = "ID da VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = module.vpc.private_subnets
}

output "web_security_group_id" {
  description = "ID do Security Group da aplicação web"
  value       = aws_security_group.web_app.id
}

output "rds_security_group_id" {
  description = "ID do Security Group do RDS"
  value       = aws_security_group.rds.id
}

output "ec2_public_ip" {
  description = "IP público da EC2"
  value       = aws_instance.app_server.public_ip
}

output "rds_endpoint" {
  description = "Endpoint do RDS PostgreSQL"
  value       = aws_db_instance.rds_instance.endpoint
}

output "bucket_name" {
  description = "Nome do bucket S3"
  value       = aws_s3_bucket.bucket.bucket
}

output "api_gateway_url" {
  description = "URL do API Gateway"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  value       = aws_dynamodb_table.pedidos.name
}