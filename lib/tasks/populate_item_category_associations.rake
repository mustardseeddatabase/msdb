namespace :ccstb do
  desc "populates the category_id and limit_category_id fields"
  task :populate_category_associations => :environment do
    categories = Category.all.inject({}){|hash, cat| hash[cat.name] = cat.id; hash}
    limit_categories = LimitCategory.all.inject({}){|hash, cat| hash[cat.name] = cat.id; hash}
    total = Item.count
    i = 0
    Item.all.each do |item|
      cat_id = categories[item.category] unless item.category.nil?
      limcat_id = limit_categories[item.limit_category] unless item.limit_category.nil?
      item.update_attribute(:category_id, cat_id)
      item.update_attribute(:limit_category_id, limcat_id)
      i += 1
      percent = (i.to_f*100/total).to_i
      print "\rItem #{i}, #{percent}%"
    end
    print "\r\n"
  end
end
