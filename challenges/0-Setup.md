# 🔥 Vulnerable Labs: Setup
*A deliberately insecure application for security education and demos*

---

## Setup

The following steps are required to set up the lab. This should take approxmately 5 minutes. 

### 🎯 Your Mission

1. Run the CloudFormation Template provided by the trainer. This may take 2-3 minutes to execute.
2. Save the SSH private key from the CloudFormation Outputs tab to your local filesystem.
4. Confirm you have two EC2 instances running. One called "WebServer" and one called "AttackerBox"
5. Open two Terminal windows and SSH to both the AttackerBox and WebServer:
```bash
ssh -i saved_ssh_key ubuntu@webserver_IP
```
```bash
ssh -i saved_ssh_key ubuntu@attackerbox_IP
```
7. Install the Wiz sensor from the [Wiz Sensor Deployment Page](https://app.wiz.io/settings/deployments/setup/sensor-linux-native) on the WebServer EC2 instance.
8. Open your web browser and browse to http://webserver_IP.
9. Can you get a high score?
