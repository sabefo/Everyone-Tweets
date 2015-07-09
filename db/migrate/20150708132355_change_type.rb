class ChangeType < ActiveRecord::Migration
  def change
  	add_column :tweets, :tweet_id, :string, unique: true
  end
end
