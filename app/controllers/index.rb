get '/' do
  # La siguiente linea hace render de la vista 
  # que esta en app/views/index.erb

  erb :index
end

post '/fetch' do
	handle = params[:twitter_handle]
	redirect to("/#{handle}")
end

post '/tweet' do
  @message = nil
    # Recibe el input del usuario
  tweet = params[:tweet]
  begin
    TWITTER.update!(tweet)
    @message = "el tweet se envio con exito"
  rescue
    @message = "el tweet ya se envio antes"
  end
  erb :index
end

post '/tweet_media' do
  @message = nil
  # Recibe el input del usuario
  tweet = params[:tweet]

  user = TwitterUser.find_by(username: session[:username])
  id = user.tweet_later(tweet)

  @message = "El Job Id es: #{id}"
  id
end


get '/sign_in' do
  # El método `request_token` es uno de los helpers
  # Esto lleva al usuario a una página de twitter donde sera atentificado con sus credenciales
  # puts "estamos llendo a: #{redirect request_token.authorize_url(:oauth_callback => "http://#{host_and_port}/auth")}"
  redirect request_token.authorize_url(:oauth_callback => "http://#{host_and_port}/auth")
  # Cuando el usuario otorga sus credenciales es redirigido a la callback_url 
  # Dentro de params twitter regresa un 'request_token' llamado 'oauth_verifier'
end

get '/auth' do
  # Volvemos a mandar a twitter el 'request_token' a cambio de un 'acces_token' 
  # Este 'acces_token' lo utilizaremos para futuras comunicaciones.   
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # Despues de utilizar el 'request token' ya podemos borrarlo, porque no vuelve a servir. 
  session.delete(:request_token)

  username = @access_token.params['screen_name']
  session[:oauth_token] = @access_token.params['oauth_token']
  session[:oauth_token_secret] = @access_token.params['oauth_token_secret']
  TwitterUser.create(username: username, oauth_token: session[:oauth_token], oauth_token_secret: session[:oauth_token_secret])
  session[:username] = username
  # Aquí es donde deberás crear la cuenta del usuario y guardar usando el 'acces_token' lo siguiente:
  # nombre, oauth_token y oauth_token_secret
  # No olvides crear su sesión 
  erb :home
end

  # Para el signout no olvides borrar el hash de session

get '/:username' do

  @handle = params[:username]
  @user = TwitterUser.find_or_create_by(username: @handle)
  # Se crea un TwitterUser si no existe en la base de datos de lo contrario trae de la base al usuario.

  tweets = Tweets.where(twitter_user_id: @user.id)

  if tweets.empty?
    tweets = TWITTER.user_timeline(username: @user.username)
    tweets.each do  |t|

      Tweets.create(twitter_user_id: @user.id, tweet: t.text, tweet_id: t.id.to_s)
    end
   # La base de datos no tiene tweets?
   # Pide a Twitter los últimos tweets del usuario y los guarda en la base de datos
  end

  if Time.now - tweets.first.created_at > 2000
    tweets = TWITTER.user_timeline(username: @user.username)
    tweets.each do  |t|
      Tweets.create(twitter_user_id: @user.id, tweet: t.text, tweet_id: t.id.to_s)
    end

    # Pide a Twitter los últimos tweets del usuario y los guarda en la base de datos
  end

  @tweets = Tweets.all.order(:created_at).limit(10)
  # Se hace una petición por los ultimos 10 tweets a la base de datos. 
  erb :tweets
end

get '/status/:job_id' do
  # regresa el status de un job a una petición AJAX
  job_id = params[:job_id]
  if job_is_complete(job_id)
    message = "Se envio el tweet"
  else
    message = "No se ha enviado"
  end
end






