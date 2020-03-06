class UsersController < ApplicationController

  def show
    @user = User.find(params[:id]) 
    @games_in_progress = Game.where(white_player_id: @user.id).or(Game.where(black_player_id: @user.id))
    @games_won = Game.where(winner_id: @user.id)   
  end

end 