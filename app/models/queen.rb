class Queen < Piece
  def valid_move?(x, y)
  (diagonal_move?(x, y) && is_on_board?(x,y) && !isObstructed?(x, y)) || (axis_move?(x, y) && is_on_board?(x,y) && !isObstructed?(x, y))
  end

  def diagonal_move?(x, y)
    (self.x_position.to_i - x.to_i).abs == (self.y_position.to_i - y.to_i).abs  
  end

  def axis_move?(x, y)
    self.x_position.to_i == x.to_i || self.y_position.to_i == y.to_i  
  end
end
