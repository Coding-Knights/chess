module GamesHelper

def get_piece(x, y, game)
    return game.pieces.where(x_position: x, y_position: y).first
end

end
