namespace :ccstb do
  desc 'marks items as canonical as defined by custom at CCStB'
  task :mark_canonical => :environment do
    marked_item_skus = [491,41,620,551,581,747,543,97,
                        364,102,541,603,640,649,608,557,
                        555,562,63,103,584,4225,230,563,
                        484,974,528,1908,280,200,567,646,
                        198,941,459,880,495,590,335,568,
                        206,508,841,306,494,990,618,62,
                        367,3333,461,8888,480,554,4011,
                        464,130,970,3896,43,947,276,
                        914,474,554,130,313,526,327,397,
                        443,1111,100,404,2011,2012].join(',')
    Item.where("sku in (#{marked_item_skus})").each{|i| i.update_attribute(:canonical, true)}
    Item.where("sku not in (#{marked_item_skus})").each{|i| i.update_attribute(:canonical, false)}
  end
end
