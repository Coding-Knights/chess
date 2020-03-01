class King < Piece
	def valid_move?(x,y, game)
		return valid_moves.include?([x,y]) 
    def get_valid_moves (game)
      valid_move = [
		  [self.x_position+1,self.y_position+1], # diagonal_up_right move
		  [self.x_position+1,self.y_position],   # right move
		  [self.x_position+1,self.y_position-1], # diagonal_down_right move
		  [self.x_position,self.y_position+1],   # up move
		  [self.x_position,self.y_position-1],   # down move
		  [self.x_position-1,self.y_position+1], # diagonal_up_left move
		  [self.x_position-1,self.y_position],   # left move
		  [self.x_position-1,self.y_position-1]  # diagonal_down_left move
	    ]
	    
	    truly_valid_moves = []
      valid_moves.each do |move|
        if self.is_on_board?(move[0], move[1]) && !selfisObstructed?(game, move)
          truly_valid_moves.push(move)
        end
      end 
      valid_moves = truly_valid_moves
      return valid_moves
      # THE FILTER METHOD EXAMPLE: valid_moves = valid_moves.filter { |move| if obstru or not board}
    end 

   #  def can_castle?(rook_position) 
   #  	if self.in_check && self.HasMoved && 
   #  	#return false if self_in_check
   #  	#return false it self has moved
   #  	#return false if rook has moved
   #  	#return false if self is_obstructed rook position
   #  	#for all of the steps between rook and the self position return false if any step is in_check
    	
   #  end

   #  def castle!(rook_position)
   #  	#return false unless self can castle rook position
 		# #save self position
   #  	#put self at rook position
   #  	#move rook to self position
   #  end	

end
