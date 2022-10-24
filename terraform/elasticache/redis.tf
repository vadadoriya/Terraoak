resource "aws_elasticache_replication_group" "foo" {
  engine                        = "redis"
  engine_version                = "6.x"
  availability_zones            = ["us-west-2a", "us-west-2b"]
  replication_group_id          = "foo"
  replication_group_description = "foo-group description"
  node_type                     = var.node_type
  number_cache_clusters         = 2
  parameter_group_name          = "default.redis6.x"
  port                          = var.port
  security_group_names = [ "" ]
  security_group_ids = [ "value" ]
  
  
  at_rest_encryption_enabled    = true
  auto_minor_version_upgrade    = true
  automatic_failover_enabled    = true
  transit_encryption_enabled    = true

  maintenance_window            = "sat:05:30-sat:06:30"
  snapshot_retention_limit      = 7
  snapshot_window               = "23:30-00:30"
  final_snapshot_identifier = "redis-snapshot-foo"

  tags = {
    Environment = "test"
  }

  timeouts {}

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
}

resource "aws_elasticache_cluster" "replica" {
  count = 1

  cluster_id           = "tf-rep-group-1-${count.index}"
  replication_group_id = "${aws_elasticache_replication_group.foo.id}"
  security_group_ids = [ "cluster_security groups" ]
  security_group_names = [ "value" ]
  
}


resource "aws_elasticache_user" "foo" {
  user_id       = var.user_id
  user_name     = var.user_name
  access_string = "on ~app::* -@all +@read +@hash +@bitmap +@geo -setbit -bitfield -hset -hsetnx -hmset -hincrby -hincrbyfloat -hdel -bitop -geoadd -georadius -georadiusbymember"
  engine        = "REDIS"
  passwords     = [var.password]
}