class Pawn < Piece
  def valid_moves?(x,y)
    valid_moves = [
       [self.x_position+2, self.y_position+2], # the pawn will move up 2 positions when is the first move
       [self.x_position+1, self.y_position+1], # the pawn will move up 1 position after the first move

  end
end
