class PiecesController < ApplicationController
  def index
  end
  def show
    # @piece = Piece.find(params[:id])
    # @piece.chosen = true
    # @piece.update # or update_attributes


    redirect_to game_path(1, chosen_num: params[:id]) # replace num with game id; replace query with above
  end 

  def edit

  end 

  def update
    
  end 
  
end
