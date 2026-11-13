# Find the latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Flask backend EC2 instance
resource "aws_instance" "flask" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.flask.id]
  key_name                    = "Tutedude_key_pair_AWS"
  associate_public_ip_address = true

  user_data = file("${path.module}/flask_user_data.sh")

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "part2-flask-backend"
    Role = "Flask Backend"
  }
}

# Express frontend EC2 instance
resource "aws_instance" "express" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.express.id]
  key_name                    = "Tutedude_key_pair_AWS"
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/express_user_data.sh", {
    flask_private_ip = aws_instance.flask.private_ip
  })

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "part2-express-frontend"
    Role = "Express Frontend"
  }
}
