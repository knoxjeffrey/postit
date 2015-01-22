module ActsAsVoteable
  
  #self.included is called when this module is included in a model
  def self.included(base)
    #class_eval allows me to define methods at runtime within the model that this module is included in
    #class_eval is useful when the class I want to add methods to is not known until runtime. 
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