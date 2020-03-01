class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def white?
    return true if piece.color == 1
  end 

  def get_enemy(piece)
    return piece.game.pieces.where('piece.color == 2') if piece.white?
    return piece.game.pieces.where('piece.color == 1')
  end 

end
