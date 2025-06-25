# 🔥 Vulnerable Labs: Setup
*A deliberately insecure application for security education and demos*

---

## Setup

The following steps are required to set up the lab. This should take approximately 5 minutes. 

### 🎯 Your Mission

1. Request the [Wiz Defend Sandbox Environment](http://lms.training.wiz.io/sandbox-aws-wiz-defend) be created.
2. Follow the lab guide and sign in to the AWS Management Console and Wiz Defend Playground Tenant.
3. Open an AWS CloudShell session in the us-east-1 region. You can use this link https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-east-1
   It will say there are no active tabs, we don't need a VPC environment, so click "Open us-east-1 environment"
4. In the terminal run 
```bash
git clone https://github.com/scotti-fletcher/injection-demo && cd injection-demo
```
5. Now run the command
```bash
chmod +x run_in_cloudshell.sh && ./run_in_cloudshell.sh
```
6. Wait until the script has completed successfully. It may take 2-3 minutes and will finish by printing Terraform outputs e.g.:
```bash
Outputs:

attacker_public_ip = "52.73.23.227" #Your IP will be different
lab_key_name = "lab_key"
private_key = <sensitive>
webserver_public_ip = "3.90.44.141" #Your IP will be different
```
7. Make note of the attacker_public_ip and webserver_public_ip as we will be using these throughout the rest of the lab. The SSH key 
8. SSH to the webserver host from the CloudShell:
```bash
ssh -i ~/lab_key.pem ubuntu@webserver_public_ip
```
8. Install the Wiz sensor from the [Wiz Sensor Deployment Page](https://app.wiz.io/settings/deployments/setup/sensor-linux-native) on the WebServer EC2 instance.
9. Browse to http://webserver_IP, see if you can get a high score. 
