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


    check_response = test_check(@piece, @x, @y)
    @piece.move_to!(@x, @y) if flash.now[:alert].empty?
    
    @game.save

    opponent = @game.opponent(current_user)
    ActionCable.server.broadcast "game_channel_user_#{opponent&.id}", move: render_movement, piece: @piece
  end 

  private

  def update_params
    @piece = Piece.find(params[:id])
    if @piece.piece_type == 'king'
      @piece = King.find(params[:id])
    elsif @piece.piece_type == 'bishop'
      @piece = Bishop.find(params[:id])
    elsif @piece.piece_type == 'knight'
      @piece = Knight.find(params[:id])
    elsif @piece.piece_type == 'queen'
      @piece = Queen.find(params[:id])
    elsif @piece.piece_type == 'pawn'
      @piece = Pawn.find(params[:id])
    elsif @piece.piece_type == 'rook'
      @piece = Rook.find(params[:id])
    end
    @game = Game.find(@piece.game_id)
  
    @x = params[:x_position].to_i
    @y = params[:y_position].to_i
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



  def test_check(piece, x, y)
    return false if piece.can_take?(helpers.get_piece(x, y, piece.game)) && piece.piece_type == 'king'
    return false if piece.can_take?(helpers.get_piece(x, y, piece.game)) && !piece.puts_self_in_check?(x, y)

    if piece.puts_self_in_check?(x, y)
      flash.now[:alert] << 'You cannot put or leave yourself in Check.'
      return false
    end

    return false unless piece.puts_enemy_in_check?(x,y)

    current_user.id == piece.game.white_player_id ? 'black king in check' : 'white king in check'

  end
end
