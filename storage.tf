resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  db_name              = "rds_instance"
  engine               = "postgres"
  engine_version       = "15.14"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres15"
  skip_final_snapshot  = true
  
  multi_az            = false
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds.id]  
  storage_type        = "gp2"
  
  #It's not in the free tier 
  #backup_retention_period = 7
}

resource "aws_s3_bucket" "bucket" {
  
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket = aws_s3_bucket.bucket.id

    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
    bucket = aws_s3_bucket.bucket.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_dynamodb_table" "pedidos" {
  name           = "pedidos"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "clienteId"
  range_key      = "pedidoId"

  attribute {
    name = "clienteId"
    type = "S"
  }

  attribute {
    name = "pedidoId"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  global_secondary_index {
    name               = "status-index"
    hash_key           = "status"
    projection_type    = "ALL"
  }
}
