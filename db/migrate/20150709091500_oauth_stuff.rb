class OauthStuff < ActiveRecord::Migration
  def change
  	add_column :twitter_users, :oauth_token, :string, unique: true
  	add_column :twitter_users, :oauth_token_secret, :string, unique: true
  end
end



