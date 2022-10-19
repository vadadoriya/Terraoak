resource "aws_ecs_cluster" "test-cluster" {
  name = "myapp-cluster"
    setting {
      name  = "containerInsights"
      value = "enabled"
  }
  tags = {
      Name = "test-app"
  }

}
resource "aws_ecs_task_definition" "test-def" {
  # All options # Must be configured
  family                   = "testapp-task"
  
  # SaC Testing - Severity: High - Set execution_role_arn to ""
  execution_role_arn       = ""
  
  # SaC Testing - Severity: High - Set task_role_arn to ""
  task_role_arn            = ""
  
  network_mode             = "awsvpc" #this mode use for fargate

  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  
  # Must be configured for task defination
  # SaC Testing - Severity: Critical - Set privileged to true
  # SaC Testing - Severity: Critical - Set readonly_root_filesystem to true
  container_definitions    = "${file("${path.module}/templates/image/image.json")}"

  volume {  
      name = "myEfsVolume"
            efs_volume_configuration {
                file_system_id= aws_efs_file_system.efs.id
                root_directory= "/"
                # SaC Testing - Severity: Critical - Set transit_encryption to disabled
                transit_encryption= "DISABLED"
                transit_encryption_port= 2999
                # authorization_config {
                #     access_point_id ="/"
                #     iam ="ENABLED"
                # }
            }
    }



  tags = {
      Name = "test-app"
      Environment="dev"
      CreatedBy=""
    }
}
resource "aws_efs_file_system" "efs" {
  creation_token = "efs-html"

  tags = {
      Name = "test-app"
      Environment="dev"
      CreatedBy=""
    }
}


resource "aws_ecs_service" "test-service" {
  
  # All options # Must be configured
  name            = "testapp-service"
  cluster         = aws_ecs_cluster.test-cluster.id
  task_definition = aws_ecs_task_definition.test-def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  network_configuration {
    # SaC Testing - Severity: Critical - Set security_groups to []
    security_groups  = []
    subnets          = aws_subnet.private.*.id
    # SaC Testing - Severity: Critical - Set assign_public_ip to false or enabled
    assign_public_ip = "enabled"
  }

  # SaC Testing - Severity: High - Set loadbalancer to null
  load_balancer {
  }

  # SaC Testing - Severity: Critical - Set iam_role to ""
  iam_role = ""
  depends_on = [aws_alb_listener.testapp, aws_iam_role_policy_attachment.ecs_task_execution_role]

  # ServiceRegistries.ContainerName /already in task defination
  # ServiceRegistries.Port /already in task defination
  # ServiceRegistries.RegistryArn /already in task defination
  tags = {
      Name = "test-app"
      Environment="dev"
      CreatedBy=""
    }
}

resource "aws_ecs_task_set" "example" {
  service         = aws_ecs_service.example.id
  cluster         = aws_ecs_cluster.test-cluster.id
  task_definition = aws_ecs_task_definition.test-def.arn

  network_configuration {
    # SaC Testing - Severity: Critical - Set security_groups to []
    security_groups  = []
    subnets          = aws_subnet.private.*.id
    # SaC Testing - Severity: Critical - Set assign_public_ip to false
    assign_public_ip = true
  }

  # SaC Testing - Severity: High - Set loadbalancer to null
  load_balancer {
  }
}