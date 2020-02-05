class GamesController < ApplicationController
	def index
		
	end

	def show
		# @game = Game.find(params[:id]) # Something like this - Chris
	end

	def new
		@game = Game.new
	end

	def create
		enemyID = gameParams[:black_player_id]
		gameName = gameParams[:name]
		@game = Game.create(:black_player_id => enemyID, :white_player_id => current_user.id, :name => gameName)
		redirect_to game_path(@game)
	end

	def edit
		@game = Game.find(params[:id])
	end

	def update
		@game = Game.find(params[:id])
		@game.update_attributes(:black_player_id => current_user.id)
		redirect_to game_path(@game)
	end

	def destroy

	end 


	private

	def gameParams
		params.require(:game).permit(:black_player_id, :name, :game_id, :white_player_id)
	end
end
