resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = var.redis_name
  replication_group_description = "Redis cluster for ${var.environment} environment"

  node_type            = "cache.t3.micro"
  port                 = 6379
  parameter_group_name = "default.redis5.0.cluster.on"

  snapshot_retention_limit = 5
  snapshot_window          = "00:00-05:00"

  subnet_group_name          = aws_elasticache_subnet_group.redis-subnet.name
  automatic_failover_enabled = true

  security_group_ids = [aws_security_group.redis.id]

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = var.node_groups
  }
}

resource "aws_elasticache_subnet_group" "redis-subnet" {
  name        = "${var.redis_name}-subnets"
  subnet_ids  = var.redis_subnet_ids
  description = "RDS subnet group"
}

resource "aws_security_group" "redis" {
  name        = "${var.environment}-redis-sg"
  description = "${var.environment} Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-redis-sg"
    Environment = var.environment
  }

  // outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "self" {
  // allows traffic from the SG itself
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.redis.id
}

resource "aws_security_group_rule" "external" {
  // allow traffic for TCP 6379
  count                    = length(var.ingress_security_group_ids)
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = element(var.ingress_security_group_ids, count.index)
  security_group_id        = aws_security_group.redis.id
}
