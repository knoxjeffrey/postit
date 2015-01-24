class PopulateCategoriesSlugs < ActiveRecord::Migration
  def change
    Category.all.each { |category| category.save }
  end
end
