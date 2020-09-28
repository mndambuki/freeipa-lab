# Terraform parameters
ENVIRONMENT       := localhost
TERRAFORM         := terraform
TF_FILES_PATH     := src
TF_BACKEND_PATH   := configuration/backend
TF_VARS_PATH      := configuration/tfvars

all: init deploy test

require:
	$(info Installing dependencies...)
	@./requirements.sh

setup-dns:
	$(info Elevating privileges...)
	@sudo -v

	$(info Configuring dnsmasq...)
	@sudo chmod 777 /etc/NetworkManager/conf.d
	@sudo chmod 777 /etc/NetworkManager/dnsmasq.d

init: setup-dns
	$(info Initializing Terraform...)
	$(TERRAFORM) init \
		-backend-config="$(TF_BACKEND_PATH)/$(ENVIRONMENT).conf" $(TF_FILES_PATH)

changes:
	$(info Get changes in infrastructure resources...)
	$(TERRAFORM) plan \
		-var=environment=$(ENVIRONMENT) \
		-var-file="$(TF_VARS_PATH)/default.tfvars" \
		-var-file="$(TF_VARS_PATH)/$(ENVIRONMENT).tfvars" \
		-out "output/tf.$(ENVIRONMENT).plan" \
		$(TF_FILES_PATH)

deploy: changes
	$(info Deploying infrastructure...)
	$(TERRAFORM) apply output/tf.$(ENVIRONMENT).plan

test:
	$(info Testing infrastructure...)
	@virsh -c "qemu:///system" list

clean-dns:
	$(info Elevating privileges...)
	@sudo -v

	$(info Restoring network configuration...)
	@sudo chmod 755 /etc/NetworkManager/conf.d
	@sudo chmod 755 /etc/NetworkManager/dnsmasq.d
	@sudo systemctl restart NetworkManager

clean: changes clean-dns
	$(info Destroying infrastructure...)
	$(TERRAFORM) destroy \
		-auto-approve \
		-var=environment=$(ENVIRONMENT) \
		-var-file="$(TF_VARS_PATH)/default.tfvars" \
		-var-file="$(TF_VARS_PATH)/$(ENVIRONMENT).tfvars" \
		$(TF_FILES_PATH)
	$(RM) -r .terraform
	$(RM) -r output/tf.$(ENVIRONMENT).plan
	$(RM) -r state/terraform.$(ENVIRONMENT).tfstate
