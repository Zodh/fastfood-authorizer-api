data "aws_iam_role" "example" {
  name = "LabRole"
}

data "aws_eks_cluster" "cluster" {
  name = "fastfood-api"
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

data "aws_db_instance" "rds" {
  db_instance_identifier = "mydb-instance"
}

data "kubernetes_secret" "fastfood_secret" {
  metadata {
    name = "fastfood-secret"
  }
}

data "kubernetes_service" "fastfood_service" {
  metadata {
    name      = "fastfood-api"
    namespace = "default"
  }
}