class Tweets < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :user
  validates :tweet_id, uniqueness: true

end
