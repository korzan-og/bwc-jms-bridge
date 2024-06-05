#!/usr/bin/env sh

echo "[+] Deploying to Confluent Cloud"

# Check if terraform is installed and initialized
if ! [ -x "$(command -v terraform)" ]; then
  echo "[-] Error: terraform is not installed." >&2
  exit 1
fi

if [ ! -d ".terraform" ]; then
  echo "[+] Initializing terraform"
  terraform init
  if [ $? -ne 0 ]; then
    echo "[-] Failed to initialize terraform"
    exit 1
  fi
fi

echo "[+] Applying terraform"
terraform apply -auto-approve -var-file=values.tfvars
if [ $? -ne 0 ]; then
  echo "[-] Failed to apply terraform"
  exit 1
fi

# Set output variables as environment variables
export KAFKA_BOOTSTRAP_SERVERS=$(terraform output -raw kafka_bootstrap_servers)
export SCHEMA_REGISTRY_URL=$(terraform output -raw sr_url)
export KAFKA_API_KEY=$(terraform output -raw kafka_api_key)
export KAFKA_API_SECRET=$(terraform output -raw kafka_api_secret)
export SCHEMA_REGISTRY_API_ID=$(terraform output -raw sr_api_key)
export SCHEMA_REGISTRY_API_SECRET=$(terraform output -raw sr_api_secret)

# Create docker jms-bridge image
echo "[+] Building docker image"
docker build -t jms-bridge .

# Run docker image
echo "[+] Running docker image"
docker-compose -p psycopate-jms up -d