#!/bin/bash
set -euxo pipefail

# Log startup output for troubleshooting
exec > >(tee -a /var/log/student-app-setup.log) 2>&1

# Install required software
apt-get update
apt-get install -y git python3 python3-venv python3-pip nodejs npm

# Download application from GitHub
mkdir -p /opt/student-registration
git clone --depth 1 --branch main \
  https://github.com/nikkiyadav/aws-student-registration_Tutedude_assessment_Flask.git \
  /opt/student-registration

# Set up Flask backend
python3 -m venv /opt/student-registration/backend/venv

/opt/student-registration/backend/venv/bin/pip install --upgrade pip

/opt/student-registration/backend/venv/bin/pip install \
  -r /opt/student-registration/backend/requirements.txt

# Set up Express frontend
cd /opt/student-registration/frontend
npm ci --omit=dev

# Create Flask systemd service
cat > /etc/systemd/system/flask-backend.service <<'EOF'
[Unit]
Description=Flask Student Registration Backend
After=network.target

[Service]
User=root
WorkingDirectory=/opt/student-registration/backend
ExecStart=/opt/student-registration/backend/venv/bin/gunicorn --workers 2 --bind 127.0.0.1:5000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Create Express systemd service
cat > /etc/systemd/system/express-frontend.service <<'EOF'
[Unit]
Description=Express Student Registration Frontend
After=network.target flask-backend.service

[Service]
User=root
WorkingDirectory=/opt/student-registration/frontend
Environment=BACKEND_URL=http://127.0.0.1:5000
ExecStart=/usr/bin/node /opt/student-registration/frontend/server.js
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start both services
systemctl daemon-reload
systemctl enable flask-backend
systemctl enable express-frontend

systemctl start flask-backend
systemctl start express-frontend

echo "Student Registration Application setup completed"
