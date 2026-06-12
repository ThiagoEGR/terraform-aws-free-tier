variable "db_username" {
  description = "Username PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password PostgreSQL"
  type        = string
  sensitive   = true
}