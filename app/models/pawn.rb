class Pawn < Piece
  def valid_move?(x,y)
    delta_x = x - self.x_position 
    delta_y = y - self.y_position 
    return false if reverse?(x,y)
    return false if isObstructed?(x,y)
    return false if !is_on_board?(x,y)
    return true  if diagonal_capture?(x,y)
    return false if delta_x != 0 
    return true  if move_two?(x,y)
    return true  if delta_y.abs == 1 
    return false #if all else fails itll return false 
  end

  def reverse?(x,y)
    delta_x = x - self.x_position
    delta_y = y - self.y_position
    return delta_y < 0 if self.color == 1
    return delta_y > 0 if self.color == 2
  end

  def diagonal_capture?(x,y)
    delta_x = x - self.x_position 
    delta_y = y - self.y_position 
    return false if delta_x.abs != 1
    if self.color == 1 && delta_y == 1 || self.color == 2 && delta_y == -1 
      enemies = game.pieces.find do |piece|
        piece.x_position == x && piece.y_position == y 
      end
      return enemies.present? 
    end 
  end

  def move_two?(x,y)
    delta_x = (x - self.x_position).abs 
    delta_y = (y - self.y_position).abs
    return delta_y <= 2 if (self.color == 1 && y_position == 1) || (self.color == 2 && y_position == 6)
    return false 
  end
end


# need to check valid move for pawn
#   - in order to check for valid move
#   - we need to check if target coordinate is:
#           -  on board
#           -  obstructed
#           -  if it is an initial move, we can move 2 spaces
#   - 
#   - 