resource "aws_elasticache_subnet_group" "redis" {
  name        = "${var.name}-subnets"
  subnet_ids  = var.subnet_ids
  description = "${var.name} subnets"
}

resource "aws_security_group" "redis" {
  name        = "${var.environment}-redis-sg"
  description = "${var.environment} Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-redis-sg"
    Environment = var.environment
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "external" {
  // allow traffic from specified subnets
  count                    = length(var.ingress_security_group_ids)
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = element(var.ingress_security_group_ids, count.index)
  security_group_id        = aws_security_group.redis.id
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.name
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  port                 = var.port
  engine_version       = "5.0.6"

  subnet_group_name  = aws_elasticache_subnet_group.redis.name
  security_group_ids = [aws_security_group.redis.id]

  snapshot_retention_limit = 5
  snapshot_window          = "00:00-05:00"
}
