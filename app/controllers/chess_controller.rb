 class ChessController < ApplicationController
	def index  
    @games = Game.available
	end  
end
