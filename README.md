# VanaDlpNode

**Vana DLP Validator Node**

Vana turns data into currency to push the frontiers of decentralized AI. It is a layer one blockchain designed for private, user-owned data. It allows users to collectively own, govern, and earn from the AI models trained on their data.


DLPs may choose to rely on a network of DLP Validators to run their DLP's proof-of-contribution (PoC). After running PoC, these validators form a consensus with each other and write the proof-of-contribution assessment back on-chain. In this model, DLPs are responsible for deploying and maintaining their validators. DLP Validators earn DLP token rewards for accurate and consistent data evaluations.

**DLP Incentives**

[Data Liquidity Pools (DLPs)](https://docs.vana.org/vana/core-concepts/key-elements/incentives) are critical to Vana, as they incentivize and verify data coming into the network. Our core strategy is to gather the highest quality data, build the best AI models, and monetize them, providing a programmable way to work with user-owned data and build the frontiers of decentralized AI. 

Site : [Vana](https://www.vana.org/) | Docs : [Vana Docs](https://docs.oceanprotocol.com/) | X : [Vana Twitter](https://x.com/withvana) |


Minimum hardware requirements:

| **Hardware** | **Minimum Requirement** |
|--------------|-------------------------|
| **CPU**      | 2 Cores                 |
| **RAM**      | 8 GB                    |
| **Disk**     | 10 GB                   |

Join : [Telegram](https://t.me/cryptoconsol)

Follow : [Twitter](https://www.x.com/cryptoconsol)

Subscribe : [Youtube](https://www.youtube.com/@cryptoconsole)



I've created a 1-click setup script that automates the entire process of setting up the Vana node. This script will:

- **Install all necessary dependencies** (Python 3.11, Poetry, Node.js, npm, Yarn).
- **Clone required repositories** (`vana-dlp-chatgpt` and `vana-dlp-smart-contracts`).
- **Set up environment variables** and configuration files.
- **Generate wallets and export private keys**.
- **Generate encryption keys** and extract necessary information.
- **Deploy smart contracts** and capture contract addresses.
- **Edit the `.env` file** with the generated private keys and addresses.
- **Register and run the validator** as a systemd service.

### Script Explanation:

- **Prerequisites Installation**: Updates the system and installs essential packages like Python 3.11, Node.js, npm, Yarn, and Git.
- **DLP Information Prompt**: Asks for DLP name, token name, and token symbol.
- **Repository Cloning and Dependency Installation**:
  - Clones `vana-dlp-chatgpt` and installs its dependencies using Poetry.
  - Clones `vana-dlp-smart-contracts` and installs dependencies with Yarn.
- **Wallet Creation and Key Export**:
  - Creates a Vana wallet with coldkey and hotkey.
  - Exports private keys and addresses for both keys.
- **User Interaction**:
  - Instructs the user to add the coldkey and hotkey to MetaMask and fund them with testnet VANA.
  - Waits for the user to confirm before proceeding.
- **Encryption Key Generation**:
  - Runs `keygen.sh` to generate encryption keys.
- **Smart Contract Deployment**:
  - Configures the `.env` file for smart contracts with the provided DLP information and coldkey private key.
  - Deploys the contracts to the Moksha testnet.
  - Extracts the deployed contract addresses.
- **Environment Configuration**:
  - Prompts for the OpenAI API key.
  - Configures the `.env` file in `vana-dlp-chatgpt` with necessary variables.
- **Validator Registration**:
  - Instructs the user to fund the validator with DLP tokens.
  - Registers and approves the validator using `vanacli`.
- **Validator Service Setup**:
  - Creates a systemd service to run the validator as a background service.
  - Starts the service and checks its status.
- **Logging**:
  - Displays the validator logs for monitoring.

### Usage Instructions:

1. **Save the Script**:
   ```bash
   git clone https://github.com/stealeruv/VanaDlpNode.git
   ```
   - Save the script above as `vana_setup.sh` in your home directory.
2. **Make the Script Executable**:
   ```bash
   chmod +x vana_cryptoconsole_setup.sh
   ```
3. **Run the Script as Root**:
   ```bash
   ./vana_cryptoconsole_setup.sh
   ```
4. **Follow the Prompts**:
   - Enter the required DLP information when prompted.
   - Follow instructions to add wallets to MetaMask and fund them.
   - Provide your OpenAI API key when asked.
   - Ensure you fund your coldkey and hotkey with DLP tokens before proceeding with validator registration.

### Important Notes:

- **User Interaction**: The script requires your input at several stages. Please read the prompts carefully and provide accurate information.
- **Security**:
  - Keep your private keys and mnemonic phrases secure. Do not share them.
  - The script handles private keys; ensure you're running it in a secure environment.
- **Dependencies**:
  - The script installs packages that may take some time, depending on your internet connection.
  - Ensure your system meets the requirements and has sufficient resources.
- **Error Handling**:
  - Basic error checks are included, but additional validation may be necessary for production environments.
- **Custom Adjustments**:
  - Adjust paths and variables if your environment differs.
  - Review the script before running to ensure it aligns with your setup.

### After Running the Script:

- **Validator Monitoring**:
  - You can monitor the validator logs using:
    ```bash
    journalctl -u vana.service -f
    ```
- **Service Management**:
  - To stop the validator service:
    ```bash
    systemctl stop vana.service
    ```
  - To start the validator service:
    ```bash
    systemctl start vana.service
    ```
  - To check the service status:
    ```bash
    systemctl status vana.service
    ```

### Disclaimer:

- **Testnet Environment**: This setup is intended for the Moksha testnet. Do not use mainnet private keys or tokens.
- **Updates**: The repositories and commands may change over time. Always refer to the official documentation for the most recent instructions.
- **Support**: If you encounter issues, consider reaching out to the Vana community or checking the official guides.

---
