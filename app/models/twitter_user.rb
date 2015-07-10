class TwitterUser < ActiveRecord::Base
  # Remember to create a migration!
  has_many :tweets
  validates :username, uniqueness: true

  def tweet(tweet)
  	client = Twitter::REST::Client.new do |config|
	    config.consumer_key        = ENV['TWITTER_KEY']
	    config.consumer_secret     = ENV["TWITTER_SECRET"]
	    config.access_token        = self.oauth_token
	    config.access_token_secret = self.oauth_token_secret
	  end


	  # user = TwitterUser.find_by(username: user.username)
	  tweets = client.user_timeline(username: self.username)
	  # Tweets.create(twitter_user_id: user.id, tweet: tweet, tweet_id: tweets[0].id.to_s)
	  # TwitterUser.create(username: username, oauth_token: oauth_token, oauth_token_secret: oauth_token_secret)
	  client.update(tweet)
  end

  def tweet_later(text)
	  # tweet = # Crea un tweet relacionado con este usuario en la tabla de tweets
	  tweet_text = Tweets.create(twitter_user_id: self.id, tweet: text)
	  # Este es un método de Sidekiq con el cual se agrega a la cola una tarea para ser ejetucada
	  puts "Este es el tweet: #{tweet_text.inspect}"
	  TweetWorker.perform_async(tweet_text.id)
	  #La última linea debe de regresar un sidekiq job id
  end
end
