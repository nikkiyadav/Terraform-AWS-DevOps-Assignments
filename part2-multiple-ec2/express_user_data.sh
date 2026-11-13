#!/bin/bash
set -euxo pipefail

# Save installation logs
exec > >(tee -a /var/log/express-setup.log) 2>&1

# Install required packages
apt-get update
apt-get install -y git nodejs npm

# Download application source code
mkdir -p /opt/student-registration

git clone --depth 1 --branch main \
  https://github.com/nikkiyadav/aws-student-registration_Tutedude_assessment_Flask.git \
  /opt/student-registration

# Install Express dependencies
cd /opt/student-registration/frontend
npm ci --omit=dev

# Set ownership
chown -R ubuntu:ubuntu /opt/student-registration

# Configure Express as a systemd service
cat > /etc/systemd/system/express-frontend.service <<'EOF'
[Unit]
Description=Express Student Registration Frontend
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/opt/student-registration/frontend
Environment=BACKEND_URL=http://${flask_private_ip}:5000
ExecStart=/usr/bin/node /opt/student-registration/frontend/server.js
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start Express
systemctl daemon-reload
systemctl enable express-frontend
systemctl start express-frontend

echo "Express frontend setup completed"
