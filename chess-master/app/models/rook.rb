class Rook < Piece
  def valid_move?(x, y)
    (axis_move?(x, y) && is_on_board?(x,y) && !isObstructed?(game, [x, y]))
  end

  def axis_move?(x, y)
    self.x_position.to_i == x.to_i || self.y_position.to_i == y.to_i  
  end
end

