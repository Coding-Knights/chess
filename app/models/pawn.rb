class Pawn < Piece
  def valid_move?(x, y)
    delta_x = x - x_position
    delta_y = y - y_position
    return false if is_reverse?(x, y)
    return false if isObstructed?(x, y)
    return true  if diagonal_capture?(x, y)
    return true  if en_passant?(x, y)
    return false if delta_x != 0 
    return false if tile_is_occupied?(x, y)
    return true  if can_move_two?(x, y)
    return true  if delta_y.abs == 1 
    return false
  end

  def is_reverse?(x, y)
    delta_x = x - x_position
    delta_y = y - y_position
    return delta_y < 0 if is_white?
    return delta_y > 0 if not is_white?
  end

  # def is_reverse?(x, y)
  #   delta_x = x - self.x_position
  #   delta_y = y - self.y_position
  #   return delta_y < 0 if self.color == 1
  #   return delta_y > 0 if self.color == 2
  # end

  def diagonal_capture?(x, y)
    delta_x = x - x_position
    delta_y = y - y_position
    return false if delta_x.abs != 1
    if is_white? && delta_y == 1 || !is_white? && delta_y == -1
      targets = game.pieces.find do |piece|
        piece.x_position == x && piece.y_position == y
      end
      return targets.present?
    end 
  end

  def tile_is_occupied?(x, y)
    return opponent_pieces.any? { |piece| piece.x_position == x && piece.y_position == y }
  end

  def can_move_two?(x, y)
    delta_x = (x - x_position).abs
    delta_y = (y - y_position).abs
    return delta_y <= 2 if (is_white? and self.y_position == 1) or (not is_white? and self.y_position == 6)
    return false
  end

  def promotable?
    return true if is_white? && y_position == 7
    return true if !is_white? && y_position == 0

    false
  end
end