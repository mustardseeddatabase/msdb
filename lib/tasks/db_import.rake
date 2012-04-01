require 'csv'


def path(env)
  if env =~ /development/i
    Pathname.new(File.join("~","Documents","ccstb_db"))
  else
    Pathname.new(File.join("/","home","ccstbrai","ccstb_import"))
  end
end

def source(filename, env)
  file = File.join( File.expand_path(path(env)), filename)
  #CSV::Reader.parse(File.open(file))
  CSV.read(file)
end

def size(filename, env)
  source(filename, env).count
end

def disable_logging
  dev_null = Logger.new("/dev/null")
  Rails.logger = dev_null
  ActiveRecord::Base.logger = dev_null
end

namespace :ccstb do
  desc 'importing client database from csv'
  task :client_import => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE clients')
    ActiveRecord::Base.connection.execute('DELETE FROM qualification_documents WHERE type = "IdQualdoc"')
    n = 0
    source_items = source('Clients.txt', Rails.env)
    total = size('Clients.txt', Rails.env)
    source_items.each do |client|
      c = Client.new
      c.household_id = client[0]
      c.firstName = client[1].gsub("\n"," ") unless client[1].nil?
      c.mi = client[2]
      c.lastName = client[3].gsub("\n"," ") unless client[3].nil?
      c.suffix = client[4]
      c.birthdate = Date.strptime(client[5], "%m/%d/%Y") unless client[5].nil?
      c.race = client[6].upcase unless client[6].nil?
      c.gender = client[7]
      c.headOfHousehold = client[8]
      c.create_id_qualdoc(:confirm => client[9],
                          :date => client[10],
                          :warnings => client[11],
                          :vi => client[12])
      if c.save(:validate => false)
        n=n+1
        GC.start if n%50==0
      end
      percent = (n.to_f*100/total).to_i
      print "\rclient #{c.id}, #{percent}%"
    end
    print "\n\r"
  end


  desc 'importing inventory database from csv'
  task :item_import => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE items')
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE categories')
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE limit_categories')
    n = 0
    source_items = source("Inventory.txt", Rails.env)
    total = size("Inventory.txt", Rails.env)
    source_items.each do |item|
      c = Item.new
      if item[0].to_i < 900
        c.sku = item[0].to_i
      else
        c.upc = item[0].to_i
      end
      # transliterate removes accented characters that seem to be a problem for the database
      c.description = ActiveSupport::Inflector.transliterate(item[1].gsub("\n"," ")).titlecase unless item[1].nil?
      c.weight_oz = item[2]
      cat = item[3].gsub("\n", " ") unless item[3].nil?
      lim_cat = item[5].gsub("\n", " ") unless item[5].nil?
      lim_cat = "Other (Non-Food)" unless cat == "Food"
      conflicting_category_data = (cat == "Food") && (lim_cat == "Other (Non-Food)")
      limit_category = LimitCategory.find_or_create_by_name(lim_cat) unless lim_cat.nil?
      category = Category.find_or_create_by_name_and_limit_category_id(cat, limit_category.id) unless cat.nil? || lim_cat.nil? || conflicting_category_data
      c.category_id = category && category.id
      c.count = item[4].to_i
      if c.save(:validate => false)
        n=n+1
        GC.start if n%50==0
      end
      percent = (n.to_f*100/total).to_i
      print "\ritem #{c.id}, #{percent}%"
    end
    print "\n\r"
  end


  desc 'importing distrib_items database from csv'
  task :distribution_items_import => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('DELETE FROM transaction_items WHERE type = "DistributionItem"')
    n = 0
    source_items = source("DistribItems.txt", Rails.env)
    total = size("DistribItems.txt", Rails.env)
    source_items.each do |item|
      c = DistributionItem.new
      #c.distribution_id = item[0].to_i
      c.transaction_id = item[0].to_i
      if item[1].to_i < 900
        i = Item.find_by_sku(item[1].to_i)
      else
        i = Item.find_by_upc(item[1].to_i)
      end
      c.item_id = i.id
      c.quantity = item[2].to_i
      i.update_attribute(:qoh, i.qoh - c.quantity)
      if c.save(:validate => false)
        n=n+1
        GC.start if n%50==0
      end
      percent = (n.to_f*100/total).to_i
      print "\rdistribution item #{c.id}, #{percent}%"
    end
    print "\n\r"
  end


  desc 'importing distributions database from csv'
  task :distributions_import => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE distributions')
    n = 0
    source_items = source("Distribution.txt", Rails.env)
    total = size("Distribution.txt", Rails.env)
    source_items.each do |item|
      c = Distribution.new
      c.id = item[0]
      c.household_id = item[1].to_i
      c.created_at = DateTime.strptime(item[2], "%m/%d/%Y %H:%M:%S") unless item[2].nil?
      if c.save(:validate => false)
        n=n+1
        GC.start if n%50==0
      end
      percent = (n.to_f*100/total).to_i
      print "\rdistribution #{c.id}, #{percent}%"
    end
    print "\n\r"
  end


  desc 'importing donated items database from csv'
  task :donated_items_import => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('DELETE FROM transaction_items WHERE type = "DonatedItem"')
    n = 0
    source_items = source("DonatedItems.txt", Rails.env)
    total = size("DonatedItems.txt", Rails.env)
    source_items.each do |item|
      c = DonatedItem.new
      #c.donation_id = item[0].to_i
      c.transaction_id = item[0].to_i
      if item[1].to_i < 900
        i = Item.find_by_sku(item[1].to_i)
      else
        i = Item.find_by_upc(item[1].to_i)
      end
      c.item_id = i.id
      c.quantity = item[2].to_i
      i.update_attribute(:qoh, i.qoh + c.quantity)
      if c.save(:validate => false)
        n=n+1
        GC.start if n%50==0
      end
      percent = (n.to_f*100/total).to_i
      print "\rdonated item #{c.id}, #{percent}%"
    end
    print "\n\r"
  end


  desc 'importing donations from csv'
  task :donations_import => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE donations')
    n = 0
    source_items = source("Donations.txt", Rails.env)
    total = size("Donations.txt", Rails.env)
    source_items.each do |item|
      c = Donation.new
      c.id = item[0].to_i
      c.donor_id = item[1].to_i
      c.created_at = DateTime.strptime(item[2], "%m/%d/%Y %H:%M:%S") unless item[2].nil?
      if c.save(:validate => false)
        n=n+1
        GC.start if n%50==0
      end
      percent = (n.to_f*100/total).to_i
      print "\rdonation #{c.id}, #{percent}%"
    end
    print "\n\r"
  end


  desc 'importing donors from csv'
  task :donor_import => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE donors')
    n = 0
    source_items = source("Donors.txt", Rails.env)
    total = size("Donors.txt", Rails.env)
    source_items.each do |item|
      c = Donor.new
      c.id = item[0].to_i
      c.organization = item[1].gsub("\n"," ") unless item[1].nil?
      c.contactName = item[2].gsub("\n"," ") unless item[2].nil?
      c.contactTitle = item[3].gsub("\n"," ") unless item[3].nil?
      c.address = item[4].gsub("\n"," ") unless item[4].nil?
      c.city = item[5].gsub("\n"," ") unless item[5].nil?
      c.state = item[6].gsub("\n"," ") unless item[6].nil?
      c.zip = item[7].gsub("\n"," ") unless item[7].nil?
      c.phone = item[8].gsub("\n"," ") unless item[8].nil?
      c.fax = item[9].gsub("\n"," ") unless item[9].nil?
      c.email = item[10].gsub("\n"," ") unless item[10].nil?
      if c.save(:validate => false)
        n=n+1
        GC.start if n%50==0
      end
      percent = (n.to_f*100/total).to_i
      print "\rdonor #{c.id}, #{percent}%"
    end
    print "\n\r"
  end


  desc 'importing households from csv'
  task :households_import => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE households')
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE addresses')
    ActiveRecord::Base.connection.execute('DELETE FROM qualification_documents WHERE type = "ResQualdoc"')
    ActiveRecord::Base.connection.execute('DELETE FROM qualification_documents WHERE type = "IncQualdoc"')
    ActiveRecord::Base.connection.execute('DELETE FROM qualification_documents WHERE type = "GovQualdoc"')
    n = 0
    source_items = source("Households.txt", Rails.env)
    total = size("Households.txt", Rails.env)
    source_items.each do |item|
      c = Household.new
      c.id = item[0].to_i
      c.created_at = Date.strptime(item[1], "%m/%d/%Y") unless item[1].nil?
      c.updated_at = Date.strptime(item[2], "%m/%d/%Y") unless item[2].nil?
      c.build_perm_address(:address => (item[3].gsub("\n",'') unless item[3].nil?), :city => (item[4].gsub("\n",'') unless item[4].nil?), :zip => (item[5].gsub("\n",'') unless item[5].nil?), :apt => (item[6].gsub("\n",'') unless item[6].nil?)) unless [item[3],item[4],item[5],item[6]].all?(&:blank?)
      c.build_temp_address(:address => (item[7].gsub("\n",'') unless item[7].nil?), :city => (item[8].gsub("\n",'') unless item[8].nil?), :zip => (item[9].gsub("\n",'') unless item[9].nil?), :apt => (item[10].gsub("\n",'') unless item[10].nil?)) unless [item[7],item[8],item[9],item[10]].all?(&:blank?)
      c.phone = item[11].gsub("\n",'') unless item[11].nil?
      c.email = item[12].gsub("\n",'') unless item[12].nil?
      c.resident_count = item[13].to_i unless item[13].nil?
      c.income = item[14].gsub(/^\D/,"").to_i unless item[14].nil?
      c.ssi = item[15] == "1"
      c.medicaid = item[16] == "1"
      c.foodstamps = item[17] == "1"
      c.homeless = item[18] == "1"
      c.physDisabled = item[19] == "1"
      c.mentDisabled = item[20] == "1"
      c.singleParent = item[21] == "1"
      c.vegetarian = item[22] == "1"
      c.diabetic = item[23] == "1"
      c.retired = item[24] == "1"
      c.unemployed = item[25] == "1"
      c.otherConcerns = ActiveSupport::Inflector.transliterate(item[26]) unless item[26].nil?
      c.create_res_qualdoc(:confirm => item[27] == "1",
                           :date => item[28] && Date.strptime(item[28], "%m/%d/%Y"),
                           :warnings => item[29].to_i,
                           :vi => (item[30] == "1"))
      c.create_inc_qualdoc(:confirm => item[31] == "1",
                           :date => item[32] && Date.strptime(item[32], "%m/%d/%Y"),
                           :warnings => item[33].to_i,
                           :vi => (item[34] == "1"))
      c.create_gov_qualdoc(:confirm => item[35] == "1",
                           :date => item[36] && Date.strptime(item[36], "%m/%d/%Y"),
                           :warnings => item[37].to_i,
                           :vi => (item[38] == "1"))
      c.usda = item[39] == "1"
      if c.save! :validate => false # some records are not valid. Import them anyway.
        n=n+1
        GC.start if n%50==0
      end
      percent = (n.to_f*100/total).to_i
      print "\rhousehold #{c.id}, #{percent}%"
    end
    print "\n\r"
  end

  desc 'importing limit categories from csv'
  task :limits_import => :environment do
    disable_logging
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE category_thresholds')
    n = 0
    source_items = source("tluLimits.txt", Rails.env)
    total = size("tluLimits.txt", Rails.env)
    source_items.each do |item|
      c = LimitCategory.find_by_name(item[0])
      (1..6).each do |i|
        cc = c.category_thresholds.build(:res_count => i, :threshold => item[i].to_i)
      end
      if c.save! :validate => false # some records are not valid. Import them anyway.
        n=n+1
        GC.start if n%50==0
      end
      percent = (n.to_f*100/total).to_i
      print "\rlimit #{c.id}, #{percent}%"
    end
    print "\n\r"
  end

  task :import_all => :environment do
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE qualification_documents')
    Rake::Task['ccstb:client_import'].invoke
    Rake::Task['ccstb:item_import'].invoke
    Rake::Task['ccstb:distribution_items_import'].invoke
    Rake::Task['ccstb:distributions_import'].invoke
    Rake::Task['ccstb:donated_items_import'].invoke
    Rake::Task['ccstb:donations_import'].invoke
    Rake::Task['ccstb:donor_import'].invoke
    Rake::Task['ccstb:households_import'].invoke
    Rake::Task['ccstb:limits_import'].invoke
  end
end
