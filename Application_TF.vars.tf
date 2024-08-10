
module "ecs" {
  source                  = "./ECS"
  vpc_id                  = "vpc-0522b8fe084db9280"
  cluster_name            = "django-notes-app-cluster"
  cluster_service_name    = "django-notes-app-service"
  cluster_service_task_name = "django-notes-app-task"
  vpc_id_subnet_list      = ["subnet-00e7bb95b770045a0", "subnet-0afb4cdf359c0816f", "subnet-06160d4dcb973b682", "subnet-03bf8a900d6535134"]
  execution_role_arn      = "arn:aws:iam::891376966913:role/ecsTaskExecutionRole"
  image_id                = "891376966913.dkr.ecr.us-east-1.amazonaws.com/notes_app:db9bbc5af0a471a97a2504cf2f567e07632c6c11"
}

