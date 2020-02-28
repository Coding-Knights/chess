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
        return piece.white? && piece.game.white_player_id == current_user.id || !piece.white? && piece.game.black_player_id == current_user.id
    end

    def whos_turn?
        return @game.white_player_id if @game.turn_number.even?
        return @game.black_player_id if @game.turn_number.odd?
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
        return piece.present? && players_piece?(piece) && whos_turn? == current_user.id && @game.state != 'Draw' 
    end
    
    def can_not_move_piece?(piece)
        return true if piece.present? 
        
        return true if piece.present? && @game.state == 'Draw'
        
        return false
    end




end
