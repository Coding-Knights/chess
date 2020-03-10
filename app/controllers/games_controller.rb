class GamesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :show, :destroy, :forfeit, :update, :edit]
	def index
		
	end

	def show
		@game = Game.find(params[:id]) # Something like this - Chris
		@chosen_num = params[:chosen_num]
		# @white_captured_pieces = @game.pieces_for_color(true).select do |piece|
		# 	piece.capture_status
		# end
		# @black_captured_pieces = @game.pieces_for_color(false).select do |piece|
		# 	piece.capture_status
		# end
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
			# make it so no one else can join
			# have it so it locks the two initial players to game
			# when someone else joins the black_player_id will change to the newest 2nd user
		end
	end

	def destroy
		@game = Game.find(params[:id])
		@game.destroy
		redirect_to root_path
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
  end

	def reload
		@game = Game.find(params[:game_id])
		flash.now[:alert] = []
		flash.now[:alert] << @game.state if @game.state.present?

		respond_to do |format|
			format.js { render 'reload' }
		end
	end

	private

	def gameParams
		params.require(:game).permit(:black_player_id, :name, :game_id, :white_player_id, :turn_number)
	end
end
