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

    def white_king
      return @game.pieces.where(piece_number: 4).first
    end
    
    def white_queenside_rook
      return @game.pieces.where(x_position: 0, y_position: 0).first
    end
  
    def white_kingside_rook
      return @game.pieces.where(x_position: 7, y_position: 0).first
    end
  
    def black_king
      return @game.pieces.where(piece_number: 10).first
    end
    
    def black_queenside_rook
      return @game.pieces.where(x_position: 0, y_position: 7).first
    end
  
    def black_kingside_rook
      return @game.pieces.where(x_position: 7, y_position: 7).first
    end
  
    def can_white_queenside_castle?(white_queenside_rook)
      return white_queenside_rook && white_king.can_castle?(white_queenside_rook) && current_user == @game.player_one
    end
  
    def can_white_kingside_castle?(white_kingside_rook)
      return white_kingside_rook && white_king.can_castle?(white_kingside_rook) && current_user == @game.player_one
    end
  
    def can_black_queenside_castle?(black_queenside_rook)
      return black_queenside_rook && black_king.can_castle?(black_queenside_rook) && current_user == @game.player_two
    end
  
    def can_black_kingside_castle?(black_kingside_rook)
      return black_kingside_rook && black_king.can_castle?(black_kingside_rook) && current_user == @game.player_two
    end
  

    def players_piece?(piece)
        return piece.is_white? && piece.game.player_one == current_user || !piece.is_white? && piece.game.player_two == current_user
    end

    def whos_turn?# returns either white or black player's ID
        return @game.white_player_id if @game.turn_number.even?
        return @game.black_player_id if @game.turn_number.odd?
    end

    def your_turn?
        last_move = @game.pieces.order('updated_at').last.moves.order('updated_at').last
        # create variable, which grabs from pieces table the last piece's last move. 
        if last_move.nil? then
        # if the last updated piece has no last move then do this
        # this means that there was no piece that moved so player one is returned
          return @game.player_one == current_user
        elsif last_move.start_piece > 5 
        # start piece is the piece_number so a number greater than 5
        # means that the last piece moved was BLACK, so player one assigned
          return @game.player_one == current_user
        elsif last_move.start_piece < 6
          return @game.player_two == current_user
        else
          return false
        end
      end

    def player_ones_turn?
      last_move = @game.pieces.order('updated_at').last.moves.order('updated_at').last
      return true if last_move.nil?
      return true if last_move.start_piece > 5
      return false 
    end
  
    def player_twos_turn?
      last_move = @game.pieces.order('updated_at').last.moves.order('updated_at').last
      return false if last_move.nil?
      return true if last_move.start_piece < 6
      return false 
    end

    def can_move_piece?(piece)
        return piece.present? && players_piece?(piece) && your_turn? 
    end

    def can_not_move_piece?(piece)
        return true if piece.present? && !players_piece?(piece) 
        return true if piece.present? && !your_turn? 
        
        return false
    end




end
