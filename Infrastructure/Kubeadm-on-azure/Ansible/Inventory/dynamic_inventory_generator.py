import json
from jinja2 import Template

# Path to the Terraform state file
state_file_path = "./../../Infrastructure/terraform.tfstate"

# Path to the Ansible dynamic inventory template file
template_file_path = "./hosts_template.ini"

# Path to the generated Ansible inventory file
inventory_file_path = "./hosts.ini"


# Load the Terraform state file
with open(state_file_path, "r") as state_file:
    state_data = json.load(state_file)

# Initialize IP addresses for master and worker
ip_masters = []
ip_workers = []
ip_data = []
ip_lb = []

# Extract IP addresses from the Terraform state
for resource in state_data["resources"]:
    if resource["type"] == "azurerm_linux_virtual_machine":  
        name = resource["instances"][0]["attributes"]["name"]
        if name.startswith("mosig-master"):
            ip_masters.append(resource["instances"][0]["attributes"]["public_ip_address"])
        elif name.startswith("mosig-worker"):
            ip_workers.append(resource["instances"][0]["attributes"]["public_ip_address"])
        elif name.startswith("mosig-data"):
            ip_data.append(resource["instances"][0]["attributes"]["public_ip_address"])
        else:
            ip_lb.append(resource["instances"][0]["attributes"]["public_ip_address"])

# Read the Ansible inventory template file
with open(template_file_path, "r") as template_file:
    template_content = template_file.read()

# Replace IP addresses in the template with retrieved IP addresses
# Render the template
template = Template(template_content)
inventory_content = template.render(ip_masters=ip_masters, ip_workers=ip_workers, ip_data=ip_data, ip_lb=ip_lb)


# Generate the Ansible inventory file
with open(inventory_file_path, "w") as inventory_file:
    inventory_file.write(inventory_content)


########################### HA Proxy Configuration ################################

# Path to HA Proxy config template file 
haproxy_template_file_path = "./../Playbooks/haproxy-config/haproxy.cfg.j2"

# Path to HA Proxy config template file 
haproxy_config_file_path = "./../Playbooks/haproxy-config/haproxy.cfg"

with open(haproxy_template_file_path, "r") as ha_template_file:
    ha_template_content = ha_template_file.read()

# Replace IP addresses in the template with retrieved IP addresses
# Render the template
ha_template = Template(ha_template_content)
ha_config_content = ha_template.render(ip_masters=ip_masters, ip_workers=ip_workers)


# Generate the Ansible inventory file
with open(haproxy_config_file_path, "w") as ha_config:
    ha_config.write(ha_config_content)