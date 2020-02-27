module GamesHelper
    include ActionView::Helpers::TagHelper

    def get_piece(x, y, game)
        return game.pieces.where(x_position: x, y_position: y).first
    end

    def black_tile?(x,y)
        return (x % 2 == 0 && y % 2 == 0 || x % 2 == 1 && y % 2 == 1) 
        # basically this gets activated from the _board.html.erb partial
        # it grabs what ever x and y that gets passed and returns true if the coords meet the parameters. 
    end

    def players_piece?(piece)
        return piece.white? && piece.game.white_player_id == current_user || !piece.white? && piece.game.black_player_id == current_user
    end

    def whos_turn?
        return white_player_id if turn_number.even?
        return black_player_id if turn_number.odd?
    end
    
    def player_ones_turn?
        turn_num = @game.turn_number
        return true if turn_num.even?
    end
    
    def player_twos_turn?
        turn_num = @game.turn_number
        return true if turn_num.odd?
    end

    def can_move_piece?(piece)
        return piece.present? && players_piece?(piece) && (whos_turn? == piece.player_id) && @game.state != 'Draw' && @game.winner.nil?
        # maybe take out @game.state here because we might not have that yet and @game.winner also
    end

    def can_not_move_piece?(piece)
        return true if piece.present? && !players_piece?(piece) 
        return true if piece.present? && !whos_turn? == piece.player_id 
        return true if piece.present? && @game.state == 'Draw'
        return true if piece.present? && @game.winner.present?
        return false
        # maybe take out game state and game winner, same reason as above
    end


end
