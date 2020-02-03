class GamesController < ApplicationController
	def index
		
	end

	def show
		# @game = Game.find(params[:id]) # Something like this - Chris
	end

	def new
		Game.new
	end

	def create
		enemyID = gameParams[:black_player_id]
		@game = Game.create(:black_player_id => enemyID, :white_player_id => current_user.id)
		redirect_to game_path(@game)
	end

	def edit
	
	end

	def update
		# add code here to chage current game's black_player_id to logged in user id or "current user id"
	end

	def destroy

	end 


	private

	def gameParams
		params.require(:game).permit(:black_player_id)
	end
end
