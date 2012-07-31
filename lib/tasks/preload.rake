require 'factory_girl'

def disable_logging
  dev_null = Logger.new("/dev/null")
  Rails.logger = dev_null
  ActiveRecord::Base.logger = dev_null
end

namespace :msdb do
  desc 'preloading client database'
  task :client_preload => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('DELETE FROM clients')
    ActiveRecord::Base.connection.execute('DELETE FROM qualification_documents WHERE type = "IdQualdoc"')
    i = 0
    80.times do
      type = (i%2).zero? ? :client_with_expired_id : :client_with_current_id
      client = FactoryGirl.create(type)
      print "\rclient #{i += 1}/80"
    end
    print "\n\r"
  end


  desc 'preloading item table'
  task :item_preload => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('DELETE FROM items')
    n = 0
    100.times do
      if n%3
        FactoryGirl.create(:item_with_sku)
      else
        FactoryGirl.create(:item_with_barcode)
      end
      print "\ritem #{n += 1}/100"
    end
    print "\n\r"
  end

  desc 'preloading distributions database'
  task :distributions_preload => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('DELETE FROM distributions')
    n = 0
    10.times do
      print "\rdistribution #{n+=1}"
    end
    print "\n\r"
  end

  desc 'preloading donations'
  task :donations_preload => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('DELETE FROM donations')
    n = 0
    10.times do
      print "\rdonation #{n += 1}"
    end
    print "\n\r"
  end

  desc 'preloading donors'
  task :donor_preload => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('DELETE FROM donors')
    n = 0
    6.times do
      FactoryGirl.create(:donor)
      print "\rdonor #{n += 1}"
    end
    print "\n\r"
  end


  desc 'preloading households'
  task :households_preload => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('DELETE FROM households')
    ActiveRecord::Base.connection.execute('DELETE FROM addresses')
    ActiveRecord::Base.connection.execute('DELETE FROM qualification_documents WHERE type = "ResQualdoc"')
    ActiveRecord::Base.connection.execute('DELETE FROM qualification_documents WHERE type = "IncQualdoc"')
    ActiveRecord::Base.connection.execute('DELETE FROM qualification_documents WHERE type = "GovQualdoc"')
    n = 0
    20.times do
      types = [:household_with_docs, :household_with_current_docs, :household_with_expired_docs]
      FactoryGirl.create(types[n%3])

      print "\rhousehold #{n += 1}"
    end
    print "\n\r"
  end

  desc "populate households with clients"
  task :households_populate => :environment do
    disable_logging
    unpopulated_households = Household.count
    unassigned_client_ids = Client.select(:id).map(&:id)
    Household.all.each do |household|
      while (unassigned_client_ids.size - (count_to_assign = (rand(8)+1))) > unpopulated_households
        break
      end
        if unpopulated_households == 1
          count_to_assign = unassigned_client_ids.size
        end
        to_be_assigned = unassigned_client_ids.sample(count_to_assign)
        unassigned_client_ids -= to_be_assigned
        to_be_assigned.each do |client_id|
          Client.find(client_id).update_attribute(:household_id, household.id)
        end

      unpopulated_households -= 1
    end
  end

  desc 'preloading limit categories'
  task :limit_categories_preload => :environment do
    limit_category_names = ["Grains",
                            "Proteins",
                            "Snacks/Desserts",
                            "Fruits",
                            "Sauces/Condiments",
                            "Vegetables",
                            "Beverages",
                            "Soups",
                            "Other (Non-Food)",
                            "Meals/Dinners",
                            "Dairy"]
    disable_logging
    ActiveRecord::Base.connection.execute('DELETE FROM limit_categories')
    n = 0
    limit_category_names.each do |limit_category_name|
      LimitCategory.create(:name => limit_category_name)
      print "\rlimit category #{n += 1}"
    end
    print "\n\r"
  end

  desc "preload categories table"
  task :categories_preload => :environment do
    categories = [{:cat_name=>"Food", :limit_category_name=>"Grains"},
                  {:cat_name=>"Food", :limit_category_name=>"Proteins"},
                  {:cat_name=>"Food", :limit_category_name=>"Snacks/Desserts"},
                  {:cat_name=>"Food", :limit_category_name=>"Fruits"},
                  {:cat_name=>"Food", :limit_category_name=>"Sauces/Condiments"},
                  {:cat_name=>"Food", :limit_category_name=>"Vegetables"},
                  {:cat_name=>"Food", :limit_category_name=>"Beverages"},
                  {:cat_name=>"Food", :limit_category_name=>"Soups"},
                  {:cat_name=>"Medical", :limit_category_name=>"Other (Non-Food)"},
                  {:cat_name=>"Hygiene", :limit_category_name=>"Other (Non-Food)"},
                  {:cat_name=>"Household", :limit_category_name=>"Other (Non-Food)"},
                  {:cat_name=>"Clothing", :limit_category_name=>"Other (Non-Food)"},
                  {:cat_name=>"Food", :limit_category_name=>"Meals/Dinners"},
                  {:cat_name=>"Food", :limit_category_name=>"Dairy"}]
    ActiveRecord::Base.connection.execute('DELETE FROM categories')
    categories.each do |category|
      Category.create(:name => category[:cat_name],
                      :limit_category_id => LimitCategory.find_by_name(category[:limit_category_name]).id)
    end
  end

  desc "preload category thresholds"
  task :category_thresholds_preload => :environment do
    thresholds = {"Beverages"=>{1=>1, 2=>1, 3=>1, 4=>1, 5=>1, 6=>1},
                  "Dairy"=>{1=>1, 2=>1, 3=>1, 4=>1, 5=>1, 6=>1},
                  "Fruits"=>{1=>3, 2=>3, 3=>4, 4=>4, 5=>5, 6=>5},
                  "Grains"=>{1=>1, 2=>1, 3=>1, 4=>2, 5=>2, 6=>4},
                  "Meals/Dinners"=>{1=>1, 2=>1, 3=>1, 4=>1, 5=>1, 6=>1},
                  "Other (Non-Food)"=>{1=>1, 2=>1, 3=>1, 4=>1, 5=>1, 6=>1},
                  "Proteins"=>{1=>3, 2=>3, 3=>3, 4=>4, 5=>4, 6=>4},
                  "Sauces/Condiments"=>{1=>5, 2=>5, 3=>5, 4=>5, 5=>5, 6=>5},
                  "Snacks/Desserts"=>{1=>3, 2=>3, 3=>3, 4=>4, 5=>5, 6=>5},
                  "Soups"=>{1=>2, 2=>2, 3=>2, 4=>3, 5=>3, 6=>3},
                  "Vegetables"=>{1=>11, 2=>12, 3=>13, 4=>16, 5=>17, 6=>20}}

    ActiveRecord::Base.connection.execute('DELETE FROM category_thresholds')
    LimitCategory.all.each do |limit_category|
      (1..6).each do |resident_count|
        CategoryThreshold.create(:limit_category_id => limit_category.id,
                                 :res_count => resident_count,
                                 :threshold => thresholds[limit_category.name][resident_count])
      end
    end
  end


  task :preload => :environment do
    ActiveRecord::Base.connection.execute('DELETE FROM qualification_documents')
    Rake::Task['msdb:client_preload'].invoke
    Rake::Task['msdb:households_preload'].invoke
    Rake::Task['msdb:households_populate'].invoke
    Rake::Task['msdb:limit_categories_preload'].invoke
    Rake::Task['msdb:categories_preload'].invoke
    Rake::Task['msdb:category_thresholds_preload'].invoke
    Rake::Task['msdb:item_preload'].invoke
    Rake::Task['msdb:donor_preload'].invoke
    Rake::Task['msdb:donations_preload'].invoke
    Rake::Task['msdb:distributions_preload'].invoke
  end
end

