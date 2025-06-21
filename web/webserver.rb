require 'sinatra'
require 'json'
require 'mongo'
require 'byebug' # This should be removed for production.


# Route: Root (/)
# Description: Serves the main index page
# Template: Uses ERB template (views/index.erb)
# Security: No authentication (by design) or rate limiting

get '/' do
  erb :index
end

# Route: Highscores (/highscores)
# Description: Returns top 3 scores as JSON
# Database:
#   - Connects to MongoDB using ENV variable
#   - Sorts by score (descending)
# Issues:
#   - No error handling for DB connection
get '/highscores' do
  content_type :json
  client = Mongo::Client.new(ENV['MONGODB_CONN'])
  db = client.use('game_db')
  scores_collection = db[:player_scores]

  scores = scores_collection.find.sort(score: -1).limit(3).to_a
  formatted_scores = scores.map.with_index do |score, index|
    {
      position: index + 1,
      player: score['player'],
      score: score['score']
    }
  end
  formatted_scores.to_json
end

# Route: Score POST (/score)
# Description: Stores new player score
post '/score' do
  request_body = request.body.read

  # Ticket #: 123456
  # Added Request Logging
  `echo #{request_body} >> logs.txt`

  score_result = JSON.parse(request_body)
  client = Mongo::Client.new(ENV['MONGODB_CONN'])
  db = client.use('game_db')
  scores_collection = db[:player_scores]
  scores_collection.insert_one(score_result)
end

# Description: Clears all scores (DANGER)
# Security Issues:
#   - No authentication protection
#   - No CSRF protection with GET request
#   - Hard deletes all records
# Critical: Should be disabled in production
get '/reset' do
  client = Mongo::Client.new(ENV['MONGODB_CONN'])
  db = client.use('game_db')
  scores_collection = db[:player_scores]
  scores_collection.delete_many({})
end