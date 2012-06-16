require 'csv'


def path(env)
  if env =~ /development/i
    Pathname.new(File.join("~","Documents","ccstb_import"))
  else
    Pathname.new(File.join("/","home","ccstbrai","ccstb_import"))
  end
end

def source(filename, env)
  file = File.join( File.expand_path(path(env)), filename)
  CSV::Reader.parse(File.open(file))
end

def size(filename, env)
  source(filename, env).count
end

namespace :ccstb do

  desc 'importing households from csv'
  task :households_check => :environment do
     n = 0
     id_list = []
     source_items = source("Households.txt", Rails.env)
     total = size("Households.txt", Rails.env)
     source_items.each do |item|
       if [item[3],item[4],item[5],item[6],item[7],item[8],item[9],item[10]].all?(&:blank?)
         n += 1
         id_list << item[0]
         print "\r\nblank addresses: #{n} "
       end
     end


     source_items = source('Clients.txt', Rails.env)
     source_items.each do |client|
       if id_list.include?(client[0])
         firstName = client[1].gsub("\n"," ") unless client[1].nil?
         lastName = client[3].gsub("\n"," ") unless client[3].nil?
         print "\r\n#{firstName} #{lastName}"
       end
     end

  end

end
