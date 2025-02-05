output "api_gateway_endpoint" {
  value = "https://${data.aws_api_gateway_rest_api.eks_api.id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_deployment.eks_api_deployment.stage_name}"
  description = "Endpoint público HTTPS do API Gateway para fazer as requisições nas APIs de Order, Person e Payment."
}

output "iam_role_arn" {
  description = "ARN do LabRole para gerenciar as permissões"
  value = data.aws_iam_role.example.arn
}

output "order_service_url" {
  value = data.kubernetes_service.order_service.status[0].load_balancer[0].ingress[0].hostname
  description = "Endpoint público do Order Service."
}

output "person_service_url" {
  value = data.kubernetes_service.person_service.status[0].load_balancer[0].ingress[0].hostname
  description = "Endpoint público do Person Service."
}

output "payment_service_url" {
  value = data.kubernetes_service.payment_service.status[0].load_balancer[0].ingress[0].hostname
  description = "Endpoint público do Payment Service."
}