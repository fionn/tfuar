output "alb_dns_name" {
  value       = module.hello_world_app.alb_dns_name
  description = "Domain name of the load balancer"
}
