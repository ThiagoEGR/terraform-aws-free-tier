
- S3: versionamento + Block Public Access total
- DynamoDB Pedidos (PAY_PER_REQUEST; PK clienteId, SK pedidoId; GSI status-index por status, projeção ALL)

resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  db_name              = "rds_instance"
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres15"
  skip_final_snapshot  = true
  
  multi_az            = false
  publicly_accessible = false
  backup_retention_period = 7
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds.id]  
  storage_type        = "gp2"
  
}

resource "aws_s3_bucket" "bucket" {
    versioning {
        enabled = true
    }

}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
    bucket = aws_s3_bucket.bucket.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

