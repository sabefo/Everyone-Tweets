class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)

    # tweet = # Encuentra el tweet basado en el 'tweet_id' pasado como argumento
  	tweet = Tweets.find(tweet_id)
    # user = # Utilizando relaciones deberás encontrar al usuario relacionado con dicho tweet
    @user = TwitterUser.find(tweet.twitter_user_id)
    id = @user.tweet(tweet.tweet)
    # Manda a llamar el método del usuario que crea un tweet (user.tweet)
	  # id = TwitterUser.tweet(user.id, tweet, session[:oauth_token], session[:oauth_token_secret])
	  tweet.update(tweet_id: id.id)
  end

end