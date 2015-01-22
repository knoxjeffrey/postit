class Vote < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :voteable, polymorphic: true
  
  #validates_uniqueness_of checks if specified attribute (:creator) is unique in the votes table
  #scope represents a narrowing of the database query
  #in this case it means a user(creator) can only vote once on say an individual post or comment but can vote
  #many times on different posts or comments
  validates_uniqueness_of :creator, scope: [:voteable_type, :voteable_id]
end