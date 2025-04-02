#!/bin/bash
cd "$(dirname "$0")/ansible"

python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

echo "✅ Ansible environment ready. Use: source venv/bin/activate"
