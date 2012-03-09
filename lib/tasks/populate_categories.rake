namespace :ccstb do
  desc "populates the categories table with names"
  task :populate_categories => :environment do
    categories = Item.all.map(&:category).uniq.compact
    categories.each do |category|
      Category.create(:name => category)
    end
  end
end
