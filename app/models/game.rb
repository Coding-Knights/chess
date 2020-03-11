class Game < ApplicationRecord
  has_many :pieces, dependent: :destroy
  has_many :users
  has_many :moves, dependent: :destroy


  scope :available, -> { where(black_player_id:  nil)}
  
  # after_create :populate_game!

  def opponent(current_user)
    current_user.id == white_player_id ? player_two : player_one
  end

  def player_one
    return nil if white_player_id.nil?
    return User.find(white_player_id)
  end

  def player_two
    return nil if black_player_id.nil?
    return User.find(black_player_id)
  end

  def player_one=(user)
    write_attribute(:white_player_id, user.id)
  end

  def player_two=(user)
    write_attribute(:black_player_id, user.id)
  end

  def get_player_one 
    if white_player_id.nil? 
      return "No Player Two"
    else
      grab_email_white
    end

  end

  def grab_email_white
    return User.find(white_player_id).email
  end

  def grab_email_black
    return User.find(black_player_id).email
  end

  def get_player_two
    if black_player_id.nil? 
      return "No Player Two"
    else
      grab_email_black
    end

    # return (not black_player_id.nil?) ? black_player_id : "No Player Two"
  end

  def whos_turn?
    return white_player_id if turn_number.even?
    return black_player_id if turn_number.odd?
  end

  def end_game(piece)
    if piece.is_white?
      update(winner_id: white_player_id, loser_id: black_player_id, state: 'Over')
    else
      update(winner_id: black_player_id, loser_id: white_player_id, state: 'Over')
    end
  end

  def populate_game!
    # White Pieces 
    (0..7).each do |i|
      Pawn.create(game_id: id, x_position: i, y_position: 1, color: 1, type: 'Pawn', player_id: white_player_id, piece_number: 5)
    end

    Rook.create(game_id: id, x_position: 0, y_position: 0, color: 1, type: 'Rook', player_id: white_player_id, piece_number: 0)
    Rook.create(game_id: id, x_position: 7, y_position: 0, color: 1, type: 'Rook', player_id: white_player_id, piece_number: 0)

    Knight.create(game_id: id, x_position: 1, y_position: 0, color: 1, type: 'Knight', player_id: white_player_id, piece_number: 1)
    Knight.create(game_id: id, x_position: 6, y_position: 0, color: 1, type: 'Knight', player_id: white_player_id, piece_number: 1)

    Bishop.create(game_id: id, x_position: 2, y_position: 0, color: 1, type: 'Bishop', player_id: white_player_id, piece_number: 2)
    Bishop.create(game_id: id, x_position: 5, y_position: 0, color: 1, type: 'Bishop', player_id: white_player_id, piece_number: 2)

    Queen.create(game_id: id, x_position: 3, y_position: 0, color: 1, type: 'Queen', player_id: white_player_id, piece_number: 3)
    King.create(game_id: id, x_position: 4, y_position: 0, color: 1, type: 'King', player_id: white_player_id, piece_number: 4)

    # Black Pieces
    (0..7).each do |i|
      Pawn.create(game_id: id, x_position: i, y_position: 6, color: 2, type: 'Pawn', player_id: black_player_id, piece_number: 11)
    end

    Rook.create(game_id: id, x_position: 0, y_position: 7, color: 2, type: 'Rook', player_id: black_player_id, piece_number: 6)
    Rook.create(game_id: id, x_position: 7, y_position: 7, color: 2, type: 'Rook', player_id: black_player_id, piece_number: 6)

    Knight.create(game_id: id, x_position: 1, y_position: 7, color: 2, type: 'Knight', player_id: black_player_id, piece_number: 7)
    Knight.create(game_id: id, x_position: 6, y_position: 7, color: 2, type: 'Knight', player_id: black_player_id, piece_number: 7)

    Bishop.create(game_id: id, x_position: 2, y_position: 7, color: 2, type: 'Bishop', player_id: black_player_id, piece_number: 8)
    Bishop.create(game_id: id, x_position: 5, y_position: 7, color: 2, type: 'Bishop', player_id: black_player_id, piece_number: 8)

    Queen.create(game_id: id, x_position: 3, y_position: 7, color: 2, type: 'Queen', player_id: black_player_id, piece_number: 9)
    King.create(game_id: id, x_position: 4, y_position: 7, color: 2, type: 'King', player_id: black_player_id, piece_number: 10)
  end

  	CAPTURED = 1  # constant instance
  	NOT_CAPTURED = 0 #constant instance

  def capture_piece(to_square, captor) # to_square = [x,y] dest, captor = piece moving
  	
  	# get piece at to_square
  	captured = getPieceAt(to_square[0],to_square[1])
  	# change status of the captured piece
  	captured.captured_status = CAPTURED
  	# clear board state - set x and y to -1, -1
  	captured.x_position = -1
  	captured.y_position = -1  	
  	# add to captured_pieces
    current_player.captured_pieces << captured
    # move captor to to_square
    setPieceAt(to_square[0],to_square[1],captor)
  end

  def getPieceAt(x, y) 
  	found_piece = game.pieces.find do |piece| 
  		piece.x_position == x && piece.y_position == y
  	end
  	found_piece
  	# need to handle if not found (eg exception or expected message)
  end
  def getPieceById(id) 
  	found_piece = game.pieces.find do |piece| 
  		piece.id == id
  	end
  	found_piece
  	# need to handle if not found (eg exception or expected message)
  end
  
  def setPieceAt(x, y, piece)
  	# check if x and y are on board
  	# check if x and y are on clear spot 
  	piece.x_position = x
  	piece.y_position = y
  end


  def check?(white)
    king = pieces_for_color(white).select { |piece| piece.type == 'King' }.first
    return false unless king

    enemies = get_enemies(king)
    enemies.any? { |enemy| enemy.can_take?(king) }
  end


  def pieces_for_color(white)
    pieces.select { |piece| piece.is_white? == white } 
  end

  def checkmate?(white)
    return false unless check?(white)
    return false if legal_moves(white) 
    true
  end

  def can_claim_draw?(current_user)
    return true if stalemate?(current_user)
    return true if fifty_move_rule?
    return false
  end

  def stalemate?(current_user)
    return false if state == 'Black King in Check.'
    return false if state == 'White King in Check.'
    return false if enough_pieces_remaining(current_user.id == white_player_id)
    return false if legal_moves(current_user.id == white_player_id)
    return true
  end

  def legal_moves(white)
    legal_moves = []
    playable_pieces(white).each do |piece|
      (0..7).each do |y|
        (0..7).each do |x|
          next if !piece.valid_move?(x,y)
          next if piece.puts_self_in_check?(x,y)
          legal_moves << piece
        end
      end
    end
    return legal_moves.present?
  end

  def enough_pieces_remaining(white) 
    return playable_pieces(white).count > 3
  end

  def playable_pieces(white)
    playable_pieces = []
    pieces_for_color(white).each do |piece|
      next if piece.x_position ==  -2 || piece.x_position == -1
      playable_pieces << piece 
    end
    return playable_pieces
  end

  def fifty_move_rule?
    return false if moves.count <= 100
    # The limit is 100 since a move in our app is only one player but in chess is for each player
    last_fifty_moves = moves.order(updated_at: :desc).limit(100) 
    return false if pawn_was_moved?(last_fifty_moves)
    return false if piece_was_captured?(last_fifty_moves)
    return true 
  end

  def pawn_was_moved?(last_fifty_moves)
    pawn_moves = last_fifty_moves.find do |move|
      move.start_piece == 5 || move.start_piece == 11
    end

    return pawn_moves.present?
  end

  def piece_was_captured?(last_fifty_moves)
    last_white_player_capture = pieces.where(x_position: -2, y_position: -2).order('updated_at').last
    last_black_player_capture = pieces.where(x_position: -1, y_position: -1).order('updated_at').last
    # The if statements are to catch if the game has zero captures. A highly unlikely scenario but easy to fix.
    if last_white_player_capture && last_black_player_capture
      return true if last_fifty_moves.last.updated_at < last_white_player_capture.updated_at 
      return true if last_fifty_moves.last.updated_at < last_black_player_capture.updated_at
      return false
    end
    if last_white_player_capture 
      return true if last_fifty_moves.last.updated_at < last_white_player_capture.updated_at
      return false
    end
    if last_black_player_capture
      return true if last_fifty_moves.last.updated_at < last_black_player_capture.updated_at
      return false
    end
    return false
  end

end
