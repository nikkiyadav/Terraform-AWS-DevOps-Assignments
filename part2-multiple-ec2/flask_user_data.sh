#!/bin/bash
set -euxo pipefail

# Save installation logs
exec > >(tee -a /var/log/flask-setup.log) 2>&1

# Install required packages
apt-get update
apt-get install -y git python3 python3-venv python3-pip

# Download application source code
mkdir -p /opt/student-registration

git clone --depth 1 --branch main \
  https://github.com/nikkiyadav/aws-student-registration_Tutedude_assessment_Flask.git \
  /opt/student-registration

# Create Python virtual environment
python3 -m venv /opt/student-registration/backend/venv

# Install Python dependencies
/opt/student-registration/backend/venv/bin/pip install --upgrade pip

/opt/student-registration/backend/venv/bin/pip install \
  -r /opt/student-registration/backend/requirements.txt

# Set ownership for the application
chown -R ubuntu:ubuntu /opt/student-registration

# Configure Flask as a systemd service
cat > /etc/systemd/system/flask-backend.service <<'EOF'
[Unit]
Description=Flask Student Registration Backend
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/opt/student-registration/backend
ExecStart=/opt/student-registration/backend/venv/bin/gunicorn --workers 1 --bind 0.0.0.0:5000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start Flask
systemctl daemon-reload
systemctl enable flask-backend
systemctl start flask-backend

echo "Flask backend setup completed"
