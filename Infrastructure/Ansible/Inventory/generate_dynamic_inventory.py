import json
from jinja2 import Template

# Path to the Terraform state file
state_file_path = "./../../Terraform/terraform.tfstate"

# Path to the Ansible dynamic inventory template file
template_file_path = "./hosts_template.ini"

# Path to the generated Ansible inventory file
inventory_file_path = "./hosts.ini"

# Load the Terraform state file
with open(state_file_path, "r") as state_file:
    state_data = json.load(state_file)

# Initialize IP addresses for GCP instances
gcp_ip_addresses = []

# Extract IP addresses from the Terraform state for Google Compute Engine instances
for resource in state_data["resources"]:
    if resource["type"] == "google_compute_instance":
        ip_address = resource["instances"][0]["attributes"]["network_interface"][0]["access_config"][0]["nat_ip"]
        gcp_ip_addresses.append(ip_address)

# Read the Ansible inventory template file
with open(template_file_path, "r") as template_file:
    template_content = template_file.read()

# Replace IP addresses in the template with retrieved IP addresses
# Render the template
template = Template(template_content)
inventory_content = template.render(ip_addresses=gcp_ip_addresses)

# Generate the Ansible inventory file
with open(inventory_file_path, "w") as inventory_file:
    inventory_file.write(inventory_content)
