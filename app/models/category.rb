class Category < ActiveRecord::Base
  include Sluggable
  
  has_many :post_categories
  has_many :posts, through: :post_categories
  
  validates :name, presence: true, uniqueness: true, length: {minimum: 2} 
  
  sluggable_column :name
  
end
