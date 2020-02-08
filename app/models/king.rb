class King < Piece
	def valid_move?(x,y)
		valid_moves = [
		  [self.x_position+1,self.y_position+1], # diagonal_up_right move
		  [self.x_position+1,self.y_position],   # right move
		  [self.x_position+1,self.y_position-1], # diagonal_down_right move
		  [self.x_position,self.y_position+1],   # up move
		  [self.x_position,self.y_position-1], # down move
		  [self.x_position-1,self.y_position+1], # diagonal_up_left move
		  [self.x_position-1,self.y_position],   # left move
		  [self.x_position-1,self.y_position-1] # diagonal_down_left move
	    ]

	    return valid_moves.include?([x,y]) 
    end  
end
