class Game < ApplicationRecord
	has_many :pieces
	has_many :users
 	scope :games_available, -> { join(games_available: true) } 
end
