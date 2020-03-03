class PiecesController < ApplicationController
  before_action :authenticate_user!

  def index
  end
  def show
    # @piece = Piece.find(params[:id])
    # @piece.chosen = true
    # @piece.update # or update_attributes


    # redirect_to game_path(1, chosen_num: params[:id]) # replace num with game id; replace query with above
  end 

  def edit

  end  

  def update
    update_params

    flash.now[:alert] << 'INVALID MOVE!!!!' unless @piece.valid_move?(@x, @y)
    flash.now[:alert] << 'Not your turn!' unless current_players_turn?(@game)


    check_response = check_test(@piece, @x, @y)
    @piece.move_to!(@x, @y) if flash.now[:alert].empty?
    
    @game.save

    opponent = @game.opponent(current_user)
    ActionCable.server.broadcast "game_channel_user_#{opponent&.id}", move: render_movement, piece: @piece
  end 

  def reload
    @piece = Piece.find(params[:piece_id])
    @game = Game.find(params[:game_id])
    flash.now[:alert] = []
    flash.now[:alert] << @game.state if @game.state.present?

    respond_to do |format|
      format.js { render 'reload' }
    end
  end

  private

  def update_params
    @piece = Piece.find(params[:id])
    @game = Game.find(@piece.game_id)
    @x = params[:x_position].to_i
    @y = params[:y_position].to_i
    @promotion = params[:promotion]
    flash.now[:alert] = []
    
  end 

  def render_movement
    respond_to do |format|
      format.js { render 'update' }
    end
  end

  def current_players_turn?(game)
    last_piece_moved = game.pieces.order('updated_at').last.moves.order('updated_at').last
    return true if last_piece_moved.nil? && game.player_one == current_user
    return false if last_piece_moved.nil?
    return true if game.player_one == current_user && last_piece_moved.start_piece > 5
    return true if game.player_two == current_user && last_piece_moved&.start_piece < 6
    return false
  end



  def check_test(piece, x, y)
    return false if piece.can_take?(helpers.get_piece(x, y, piece.game)) && piece.type == 'King'
    return false if piece.can_take?(helpers.get_piece(x, y, piece.game)) && !piece.puts_self_in_check?(x, y)

    if piece.puts_self_in_check?(x, y)
      flash.now[:alert] << 'You cannot put or leave yourself in Check.'
      return false
    end

    return false unless piece.puts_enemy_in_check?(x,y)

    current_user.id == piece.game.white_player_id ? 'black king in check' : 'white king in check'

    current_user.id == piece.game.white_player_id ? 'Black King in Check.' : 'White King in Check.'
  end
end
