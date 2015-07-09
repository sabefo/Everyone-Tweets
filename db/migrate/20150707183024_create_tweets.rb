class CreateTweets < ActiveRecord::Migration
  def change
  	create_table :tweets do  |t|
  		t.integer :twitter_user_id
  		t.string :tweet

  		t.timestamps
  	end
  end
end
