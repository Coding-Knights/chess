class Bishop < Piece
  def valid_move?(x, y)
    (diagonal_move?(x, y) && is_on_board?(x,y) && !isObstructed?(x, y))
  end

  # example initially at (0,0) wanna go to (1,1)
  # convert all coordiantes to integers
  # subtract initial coordinate minus target coordinate
  # get absolute value of result to avoid negative numbers
  #return true/false above

  # absolute values have to equal eachother because we are wanting to traverse diagonally(in 4 degrees of movement) and no other way. 
  def diagonal_move?(x, y)
    (self.x_position.to_i - x.to_i).abs == (self.y_position.to_i - y.to_i).abs  
  end
end
