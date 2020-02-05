class GamesController < ApplicationController
	def index
		
	end

	def show
		# @game = Game.find(params[:id]) # Something like this - Chris
	end

	def new
		@game = Game.new(:name => current_user.email, :white_player_id => current_user.id)
		@game.save
		redirect_to game_path(@game)
	end

	def create
		enemyID = gameParams[:black_player_id]
		@game = Game.create(:black_player_id => enemyID, :white_player_id => current_user.id)
		redirect_to game_path(@game)
	end

	def edit
	
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
		params.require(:game).permit(:black_player_id)
	end
end
