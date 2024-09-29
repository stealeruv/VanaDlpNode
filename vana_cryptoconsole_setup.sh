#!/bin/bash

# Function to print messages
print_info() {
    echo -e "\033[1;32m$1\033[0m"
}

print_error() {
    echo -e "\033[1;31m$1\033[0m"
}

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root"
    exit
fi

# Update and install prerequisites
print_info "Updating system and installing prerequisites..."
apt update && apt upgrade -y
apt install -y software-properties-common curl git

# Install Python 3.11
print_info "Installing Python 3.11..."
add-apt-repository ppa:deadsnakes/ppa -y
apt update
apt install -y python3.11 python3.11-venv python3.11-dev python3-pip

# Verify Python installation
python3.11 --version

# Install Poetry
print_info "Installing Poetry..."
curl -sSL https://install.python-poetry.org | python3.11 -

echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bash_profile
source $HOME/.bash_profile

# Verify Poetry installation
poetry --version

# Install Node.js and npm using NVM
print_info "Installing Node.js and npm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bash_profile
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> $HOME/.bash_profile
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> $HOME/.bash_profile

source $HOME/.bash_profile

nvm install --lts

# Verify Node.js and npm installation
node -v
npm -v

# Install Yarn
print_info "Installing Yarn..."
npm install -g yarn
yarn --version

# Prompt for DLP Information
print_info "Enter DLP Information:"
read -p "Enter DLP Name: " DLP_NAME
read -p "Enter DLP Token Name: " DLP_TOKEN_NAME
read -p "Enter DLP Token Symbol: " DLP_TOKEN_SYMBOL

# Clone vana-dlp-chatgpt repository
print_info "Cloning vana-dlp-chatgpt repository..."
cd $HOME
git clone https://github.com/vana-com/vana-dlp-chatgpt.git
cd vana-dlp-chatgpt

# Install dependencies using Poetry
print_info "Installing dependencies with Poetry..."
poetry install

# Install Vana CLI
print_info "Installing Vana CLI..."
pip install vana

# Create wallet
print_info "Creating Vana wallet..."
vanacli wallet create --wallet.name default --wallet.hotkey default

print_info "Please follow the prompts to set a secure password and save the mnemonic phrases securely."

# Prompt user to input private keys manually
print_info "Enter your private keys manually:"

read -p "Enter Coldkey Private Key: " COLDKEY_PRIVATE_KEY
read -p "Enter Hotkey Private Key: " HOTKEY_PRIVATE_KEY

# Display the inputted private keys
print_info "Coldkey Private Key: $COLDKEY_PRIVATE_KEY"
print_info "Hotkey Private Key: $HOTKEY_PRIVATE_KEY"

# Prompt user to input wallet addresses manually
print_info "Enter your wallet addresses manually:"

read -p "Enter Coldkey Address: " COLDKEY_ADDRESS
read -p "Enter Hotkey Address: " HOTKEY_ADDRESS

# Display the inputted wallet addresses
print_info "Coldkey Address: $COLDKEY_ADDRESS"
print_info "Hotkey Address: $HOTKEY_ADDRESS"


# Prompt user to add wallets to MetaMask and fund with testnet VANA
print_info "Please add your coldkey and hotkey addresses to MetaMask and fund them with testnet VANA from https://faucet.vana.org"
print_info "Press Enter after you have funded your wallets..."
read -p ""

# Generate Encryption Keys
print_info "Generating encryption keys..."
chmod +x keygen.sh
./keygen.sh

# Clone vana-dlp-smart-contracts repository
print_info "Cloning vana-dlp-smart-contracts repository..."
cd $HOME
rm -rf vana-dlp-smart-contracts
git clone https://github.com/stealeruv/vana-dlp-smart-contracts.git
cd vana-dlp-smart-contracts

# Install dependencies
print_info "Installing smart contract dependencies..."
yarn install

# Copy .env.example to .env
cp .env.example .env

# Edit .env file
print_info "Configuring .env file for smart contracts..."
sed -i "s|^PRIVATE_KEY=.*|PRIVATE_KEY=\"${COLDKEY_PRIVATE_KEY}\"|" .env
sed -i "s|^DLP_NAME=.*|DLP_NAME=\"${DLP_NAME}\"|" .env
sed -i "s|^DLP_TOKEN_NAME=.*|DLP_TOKEN_NAME=\"${DLP_TOKEN_NAME}\"|" .env
sed -i "s|^DLP_TOKEN_SYMBOL=.*|DLP_TOKEN_SYMBOL=\"${DLP_TOKEN_SYMBOL}\"|" .env

# Deploy contracts
print_info "Deploying smart contracts to Moksha testnet..."
npx hardhat deploy --network moksha --tags DLPDeploy

# Prompt user for deployed contract addresses
print_info "Please provide the deployed contract addresses."
read -p "Enter DataLiquidityPool Contract Address: " DLP_MOKSHA_CONTRACT
read -p "Enter DataLiquidityPoolToken Contract Address: " DLP_TOKEN_MOKSHA_CONTRACT

# Validate if the input is empty
if [ -z "$DLP_MOKSHA_CONTRACT" ] || [ -z "$DLP_TOKEN_MOKSHA_CONTRACT" ]; then
  print_error "Error: Both contract addresses must be provided."
  exit 1
fi

# Show the provided addresses
print_info "DataLiquidityPool Contract Address: $DLP_MOKSHA_CONTRACT"
print_info "DataLiquidityPoolToken Contract Address: $DLP_TOKEN_MOKSHA_CONTRACT"

# Get OpenAI API Key from user
print_info "Enter your OpenAI API Key (get it from https://platform.openai.com/account/api-keys):"
read -p "OpenAI API Key: " OPENAI_API_KEY

# Update .env file in vana-dlp-chatgpt
print_info "Configuring .env file for vana-dlp-chatgpt..."
cd $HOME/vana-dlp-chatgpt

PUBLIC_KEY_BASE64=$(cat public_key_base64.asc)

cat > .env <<EOL
# The network to use, currently Vana Moksha testnet
OD_CHAIN_NETWORK=moksha
OD_CHAIN_NETWORK_ENDPOINT=https://rpc.moksha.vana.org

# Optional: OpenAI API key for additional data quality check
OPENAI_API_KEY="${OPENAI_API_KEY}"

# Your own DLP smart contract address once deployed to the network
DLP_MOKSHA_CONTRACT=${DLP_MOKSHA_CONTRACT}
# Your own DLP token contract address once deployed to the network
DLP_TOKEN_MOKSHA_CONTRACT=${DLP_TOKEN_MOKSHA_CONTRACT}

# The private key for the DLP
PRIVATE_FILE_ENCRYPTION_PUBLIC_KEY_BASE64="${PUBLIC_KEY_BASE64}"
EOL

# Fund Validator with DLP Tokens
print_info "Please import the DLP token to MetaMask using the DataLiquidityPoolToken address: ${DLP_TOKEN_MOKSHA_CONTRACT}"
print_info "Send 10 of your DLP tokens to your coldkey and hotkey addresses."
print_info "Press Enter after you have funded your wallets with DLP tokens..."
read -p ""

# Register as a Validator
print_info "Registering as a validator..."
cd $HOME/vana-dlp-chatgpt
./vanacli dlp register_validator --stake_amount 10

print_info "Approving validator..."
./vanacli dlp approve_validator --validator_address=${HOTKEY_ADDRESS}

# Run Validator
print_info "Setting up Vana validator service..."

# Find path of Poetry
POETRY_PATH=$(which poetry)

# Create systemd service
cat > /etc/systemd/system/vana.service <<EOL
[Unit]
Description=Vana Validator Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$HOME/vana-dlp-chatgpt
ExecStart=${POETRY_PATH} run python -m chatgpt.nodes.validator
Restart=on-failure
RestartSec=10
Environment=PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$HOME/vana-dlp-chatgpt/myenv/bin
Environment=PYTHONPATH=$HOME/vana-dlp-chatgpt

[Install]
WantedBy=multi-user.target
EOL

# Start service
print_info "Starting Vana validator service..."
systemctl daemon-reload
systemctl enable vana.service
systemctl start vana.service

# Check service status
systemctl status vana.service

# Show logs
print_info "Displaying validator logs..."
journalctl -u vana.service -f
