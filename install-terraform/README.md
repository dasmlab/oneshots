# Install Terraform

Installs the Terraform packages on a Ubuntu system.

After you run this, you can do "terraform init" and start .tf'ing away :)

# 1. Install HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# 2. Add the official HashiCorp APT repo
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# 3. Update and install Terraform
sudo apt update && sudo apt install terraform -y

