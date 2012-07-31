class Pantry < ActiveRecord::Base
  has_many :users
  has_many :disributions
end
