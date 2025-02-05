data "aws_iam_role" "example" {
  name = "LabRole"
}

data "aws_eks_cluster" "cluster" {
  name = "fastfood-api"
}

data "aws_api_gateway_rest_api" "eks_api" {
  name = "EKS_API_Gateway"
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

data "aws_db_instance" "rds" {
  db_instance_identifier = "postgres-person"
}

data "kubernetes_secret" "fastfood_secret" {
  metadata {
    name = "fastfood-secret"
  }
}

data "kubernetes_service" "person_service" {
  metadata {
    name      = "person-service"
    namespace = "default"
  }
}

data "kubernetes_service" "order_service" {
  metadata {
    name      = "order-service"
    namespace = "default"
  }
}

data "kubernetes_service" "payment_service" {
  metadata {
    name      = "payment-service"
    namespace = "default"
  }
}