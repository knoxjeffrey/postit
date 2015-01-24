class PopulateUsersSlugs < ActiveRecord::Migration
  def change
    User.all.each { |user| user.save }
  end
end
