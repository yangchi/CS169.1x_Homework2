class Movie < ActiveRecord::Base
 @@all_ratings = ['G', 'PG', 'PG-13', 'R']
 cattr_accessor :all_ratings
end
