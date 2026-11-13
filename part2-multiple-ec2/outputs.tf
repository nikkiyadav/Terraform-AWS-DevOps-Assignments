# Flask backend details
output "flask_instance_id" {
  description = "Flask backend EC2 instance ID"
  value       = aws_instance.flask.id
}

output "flask_public_ip" {
  description = "Public IP address of Flask backend"
  value       = aws_instance.flask.public_ip
}

output "flask_private_ip" {
  description = "Private IP address of Flask backend"
  value       = aws_instance.flask.private_ip
}

output "flask_application_url" {
  description = "Flask backend application URL"
  value       = "http://${aws_instance.flask.public_ip}:5000"
}

# Express frontend details
output "express_instance_id" {
  description = "Express frontend EC2 instance ID"
  value       = aws_instance.express.id
}

output "express_public_ip" {
  description = "Public IP address of Express frontend"
  value       = aws_instance.express.public_ip
}

output "express_private_ip" {
  description = "Private IP address of Express frontend"
  value       = aws_instance.express.private_ip
}

output "express_application_url" {
  description = "Express frontend application URL"
  value       = "http://${aws_instance.express.public_ip}:3000"
}