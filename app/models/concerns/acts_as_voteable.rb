module ActsAsVoteable
  
  def self.included(base)
    base.class_eval do
      has_many :votes, as: :voteable
    end
  end
  
  def total_votes
    up_votes - down_votes
  end
  
  def up_votes
    self.votes.where(vote: true).size
  end
  
  def down_votes
    self.votes.where(vote: false).size
  end
  
end