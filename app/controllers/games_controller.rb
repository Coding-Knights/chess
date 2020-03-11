class GamesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :show, :destroy, :forfeit, :update, :edit]
	def index
		
	end

	def show
		@game = Game.find(params[:id]) 
		@chosen_num = params[:chosen_num]
	end

	def new
		@game = Game.new  
	end

	def create 
		enemyID = gameParams[:black_player_id]
		gameName = gameParams[:name]
		initial_turn = gameParams[:turn_number]
		@game = Game.create(:black_player_id => enemyID, :white_player_id => current_user.id, :name => gameName, :turn_number => initial_turn)
		redirect_to game_path(@game)

	end

	def edit
		@game = Game.find(params[:id])
	end

	def update
		@game = Game.find(params[:id])

		if current_user.id == @game.white_player_id
			redirect_to game_path(@game)

		else
			@game.update_attributes(:black_player_id => current_user.id)
			@game.populate_game!
			Pusher.trigger("channel-#{@game.id}", 'update-piece', message: 'Player 2 has joined game')
			redirect_to game_path(@game)
		end
	end

	def destroy
		@game = Game.find(params[:id])
		@game.update(state: 'Destroyed')
		@game.destroy
		redirect_to game_path(@game)
		Pusher.trigger("channel-#{@game.id}", 'update-piece', message: 'A player has destroyed game!')
	end

  def forfeit
    @game = Game.find(params[:id])
    @game.update(state: 'Forfeited')


    if current_user.id == @game.white_player_id
      @game.update(winner_id: @game.black_player_id)
      @game.update(loser_id: @game.white_player_id)
    else
      @game.update(winner_id: @game.white_player_id)
      @game.update(loser_id: @game.black_player_id)
	end
	@game.save
	redirect_to game_path(@game)
	Pusher.trigger("channel-#{@game.id}", 'update-piece', message: 'A player has forfeited')
  end


	private

	def gameParams
		params.require(:game).permit(:black_player_id, :name, :game_id, :white_player_id, :turn_number)
	end
end