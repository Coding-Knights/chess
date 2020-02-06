class Game < ApplicationRecord
	has_many :pieces
	has_many :users

	scope :available, -> { where(black_player_id:  nil)}
  
end