output "frontend_public_ip" {
  value = aws_instance.app.public_ip
}
