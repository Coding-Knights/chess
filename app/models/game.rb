class Game < ApplicationRecord
	has_many :pieces
	has_many :users
 	scope :game_available, -> { where(game_available: true) }
end
