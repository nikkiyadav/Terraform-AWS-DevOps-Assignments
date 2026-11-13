# Security group for the Express frontend
resource "aws_security_group" "express" {
  name        = "part2-express-sg"
  description = "Allow public frontend access and restricted SSH"
  vpc_id      = aws_vpc.main.id

  # Public access to Express frontend
  ingress {
    description = "Public Express frontend"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access only from your public IP
  ingress {
    description = "SSH from administrator"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "part2-express-sg"
  }
}

# Security group for the Flask backend
resource "aws_security_group" "flask" {
  name        = "part2-flask-sg"
  description = "Public access to Flask backend"
  vpc_id      = aws_vpc.main.id

  # Public access to Flask backend
  ingress {
    description = "Public Flask backend access"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access only from your public IP
  ingress {
    description = "SSH from administrator"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "part2-flask-sg"
  }
}
