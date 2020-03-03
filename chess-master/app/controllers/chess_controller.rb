 class ChessController < ApplicationController
	def index  
	@games = Game.available

	if user_signed_in?
		@games_in_progress = Game.where(white_player_id: current_user.id).or(Game.where(black_player_id: current_user.id))
	end
	
	end  
end
