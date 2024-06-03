# **Terraform-Ansible Project :smile:**
### In this we will make a jenkins terraform ansible pipeline.
![Architecture](https://github.com/sudhajobs0107/Monitoring-2-Tier/blob/main/images/monitoring-diagram.gif)

___
# Prerequisites
### Before starting the project you should have these things in your system :-
>+ ### Account on AWS
>+ ### Code [click here for code](https://github.com/sudhajobs0107/2-Tier-Flask-App-and-MYSQL)
___
## STEP 1: Launch Instance

+ ### Create AWS EC2 instance
![running-ec2](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/running-ec2.PNG)
+ ### Connect to instance through ssh :-
![ssh](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/ssh.PNG)
+ ### Now create a S3 bucket :-
![create-bucket](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/create-bucket.PNG)
+ ### Bucket created :-
![bucket](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/bucket.PNG)
___

# **Part 2** : **Setup Jenkins**
+ ### Now to install Jenkins, first we need Java install because Jenkins need Java so for to install Java use command :-
```
sudo apt upgrade && sudo apt upgrade -y
sudo apt install fontconfig openjdk-17-jre
```
+ ### To check Java version use command :-
```
java --version
```
+ ### After installing Java, we will install Jenkins so for to install Jenkins use command :-
```
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```
+ ### To check Jenkins status, use command :-
```
sudo service jenkins status
```
![java&jenkins](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/java%26jenkins.PNG)
+ ### Now copy **Public IPv4 address:8080** and we will be on **Unlock Jenkins page**. To unlock jenkins, use command :-
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
+ ### And we will get our password. Copy and paste it to unlock Jenkins → Now click Install suggested plugins → Fill details → Welcome to Jenkins
![jenkins-dash](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/jenkins-dash.PNG)
___
# **Part 2** : **Terraform** 
+ ### To install terraform use command :-
```
sudo apt update && sudo apt install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
        sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
        gpg --no-default-keyring \
        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        --fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt -y install terraform

terraform --version
```
![terra-v](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/terra-v.PNG)
___
# **Part 3** : **Ansible** 
+ ### To install ansible use command :-
```
sudo apt update
sudo apt -y install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt -y install ansible
ansible --version
```
![ansi-v](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/ansi-v.PNG)
+ ### Now make sure you have installed python3 & boto3 :-
```
python3 --version
```
![python3&bot3](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/python3%26boto3.PNG)
+ ### Now create a file named aws_ec2.yaml in the /opt directory :-
```
sudo vi /opt/aws_ec2.yaml
```
+ ### You can change the inventory location as per your requirement but you have to specify your inventory location in ansible configuration file.
 
+ ### Now write the following configuration in aws_ec2.yaml file :- 
![awsec2_file](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/aws_ec2_file.PNG)
### **Note: You can change the tags as per the requirement.**

+ ### Create a role with admin access policy and attach it to the server.

### **Note: if you don’t want to Create role then you can put access and secret keys in the aws_ec2.yaml but it is not a good practice.**

+ ### Now to enable EC2 plugin, open /etc/ansible/ansible.cfg file :-
```
sudo vi /etc/ansible/ansible.cfg
```
+ ### Find the [default] section and add the following line to inventory :-
```
inventory = /opt/aws_ec2.yaml
private_key_file = /etc/ansible/sudha_key.pem
host_key_checking = False
```
+ ### Find the [inventory] section and add the following line to enable the ec2 plugin.
```
enable_plugins = aws_ec2
```
+ ### Now open /etc/ansible/hosts file :-
```
sudo vi /etc/ansible/hosts
```
+ ### And add the following line as given below :-
![add-this-in-host](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/add-this-in-host.PNG)

+ ### Also copy key file from local system to /etc/ansible through scp.
![scp](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/scp.PNG)
![mv-key](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/mv-key.PNG)
+ ### Now install AWS CLI v2 (run these commands in home directory) :-
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin --update
```
+ ### Now we have to configure AWS CLI, for this we need IAM user. So to make IAM user, Go To IAM → Create user → Username → Next → Attach policies directly → select **AdministratorAccess** → Next → Create User. Now we will make security credentials. **Why? Because our AWS CLI can do identify my account.**  Now go to User → Security Credentials → Create access key → select CLI → Next → Create access key. So we will get **Access key** and **Secret access key**. Now go to instance and write command given below :-
```
aws configure
```
+ ### Now paste **Access key** and **Secret access key**.
![configure](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/configure.PNG)
+ ### Now it’s time to test our dynamic inventory. Run the below ad hoc command to test our dynamic inventory :-
```
ansible-inventory -i /opt/aws_ec2.yaml --list
```
+ ### Change permission 744 of aws_ec2.yaml file and ansible.cfg file. Also change permission 644 of key file.
+ ### Now build a pipeline click on **Create a job** → give name "**Terraform-Ansible-Project**" → select "**Freestyle project**" → click **OK**.
![new-item](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/new-item.PNG)
+ ### Now add choice & string parameters :-
![coice-para](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/choice-para.PNG)
![string-para](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/string-para.PNG)
+ ### Now select **git** in Source Code management :-
![add-git-repo](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/add-git-repo.PNG)
+ ### Now in Build Steps select Executive Shell and add the script given below :-
```
#!/bin/bash
set -xe

cd Terraform

sed -i "s/server_name/${SERVER_NAME}/g" backend.tf
export TF_VAR_name=${SERVER_NAME}

terraform init
terraform plan
terraform $TERRAFORM_ACTION -auto-approve

sleep 60

if [ $TERRAFORM_ACTION = "destroy" ]; then
	exit 0
else
	cd ../Ansible
        pip install boto3 --break-system-packages
	ansible-playbook -i /opt/aws_ec2.yaml apache.yaml 
fi
```
### Now click Apply and Save → **Build Now** and our pipeline will build successfully.
![build](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/build.PNG)
+ ### In this we created 2 ec2 instances through terraform and deploy simple website through ansible.
![deploy-my-website](https://github.com/sudhajobs0107/Terraform-Ansible-Project/blob/main/images/deploy-my-website.PNG)


___
## **Our Terraform-Ansible Project Completed :smile:**.
___
