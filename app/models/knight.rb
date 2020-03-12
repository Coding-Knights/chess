class Knight < Piece
  def valid_move?(x,y)
    return false if players_own_piece_is_there?(x, y)
    valid_moves = [
      [self.x_position-2,self.y_position+1], # up 1   | left 2    #
      [self.x_position-1,self.y_position+2], # up 2   | left 1    #
      [self.x_position+1,self.y_position+2], # up 2   | right 1   #
      [self.x_position+2,self.y_position+1], # up 1   | right 2   #
      [self.x_position-2,self.y_position-1], # down 1 | left 2    #
      [self.x_position-1,self.y_position-2], # down 2 | left 1    #
      [self.x_position+1,self.y_position-2], # down 2 | right 1   #
      [self.x_position+2,self.y_position-1]  # down 1 | right 2   #
      ]
      return valid_moves.include?([x,y]) 
    end
end
