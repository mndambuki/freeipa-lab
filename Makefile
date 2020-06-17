# Terraform parameters
environment=localhost
tf_cmd=terraform
tf_files=src
tf_backend_conf=configuration/backend
tf_variables=configuration/tfvars
libvirt_pool_dir=/var/lib/libvirt/storage
libvirt_imgs_dir=/var/lib/libvirt/images

all: init plan deploy test
requirements:
	@echo "Installing dependencies..."
	@./requirements.sh
init:
	@echo "Elevating privileges..." && sudo -v

	@echo "Initializing Terraform plugins"
	terraform init \
		-backend-config="$(tf_backend_conf)/$(environment).conf" $(tf_files)

	@echo "Configuring dnsmasq..."
	@sudo chmod 777 /etc/NetworkManager/conf.d
	@sudo chmod 777 /etc/NetworkManager/dnsmasq.d
plan:
	@echo "Planing infrastructure changes..."
	terraform plan \
		-var-file="$(tf_variables)/default.tfvars" \
		-var-file="$(tf_variables)/$(environment).tfvars" \
		-out "output/tf.$(environment).plan" \
		$(tf_files)
deploy:
	@echo "Deploying infrastructure..."
	terraform apply output/tf.$(environment).plan
test:
	@echo "Testing infrastructure..."
	@virsh -c "qemu:///system" list
destroy: plan
	@echo "Elevating privileges..." && sudo -v

	@echo "Destroying infrastructure..."
	terraform destroy \
		-auto-approve \
		-var-file="$(tf_variables)/default.tfvars" \
		-var-file="$(tf_variables)/$(environment).tfvars" \
		$(tf_files)
	@rm -rf .terraform
	@rm -rf output/tf.$(environment).plan
	@rm -rf state/terraform.$(environment).tfstate*

	@echo "Restoring network configuration..."
	@sudo chmod 755 /etc/NetworkManager/conf.d
	@sudo chmod 755 /etc/NetworkManager/dnsmasq.d
	@sudo systemctl restart NetworkManager