 class ChessController < ApplicationController
	def index
    #Once scope task is complete and game.available can be called then will delete line 6 and uncomment line 5
    #For now is calling all games but since we have no games yet will not show any games on home page    
    #@games = Game.available
     @games = Game.all
	end

  
end
