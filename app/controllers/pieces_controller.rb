class PiecesController < ApplicationController
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

    check_response = test_check(@piece, @x, @y)
    
    
  end 

  private

  def update_params
    @piece = Piece.find(params[:id])
    @game = Game.find(@piece.game_id)
    @x = params[:x_position].to_i
    @y = params[:y_position].to_i
    flash.now[:alert] = []
  end
  
end
