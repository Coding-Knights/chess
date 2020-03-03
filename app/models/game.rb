class Game < ApplicationRecord
  has_many :pieces
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

  def populate_game!
    # White Pieces 
    (0..7).each do |i|
      Pawn.create(game_id: id, x_position: i, y_position: 1, color: 1, piece_type: 'pawn', player_id: white_player_id, piece_number: 5)
    end

    Rook.create(game_id: id, x_position: 0, y_position: 0, color: 1, piece_type: 'rook', player_id: white_player_id, piece_number: 0)
    Rook.create(game_id: id, x_position: 7, y_position: 0, color: 1, piece_type: 'rook', player_id: white_player_id, piece_number: 0)

    Knight.create(game_id: id, x_position: 1, y_position: 0, color: 1, piece_type: 'knight', player_id: white_player_id, piece_number: 1)
    Knight.create(game_id: id, x_position: 6, y_position: 0, color: 1, piece_type: 'knight', player_id: white_player_id, piece_number: 1)

    Bishop.create(game_id: id, x_position: 2, y_position: 0, color: 1, piece_type: 'bishop', player_id: white_player_id, piece_number: 2)
    Bishop.create(game_id: id, x_position: 5, y_position: 0, color: 1, piece_type: 'bishop', player_id: white_player_id, piece_number: 2)

    Queen.create(game_id: id, x_position: 3, y_position: 0, color: 1, piece_type: 'queen', player_id: white_player_id, piece_number: 3)
    King.create(game_id: id, x_position: 4, y_position: 0, color: 1, piece_type: 'king', player_id: white_player_id, piece_number: 4)

    # Black Pieces
    (0..7).each do |i|
      Pawn.create(game_id: id, x_position: i, y_position: 6, color: 2, piece_type: 'pawn', player_id: black_player_id, piece_number: 11)
    end

    Rook.create(game_id: id, x_position: 0, y_position: 7, color: 2, piece_type: 'rook', player_id: black_player_id, piece_number: 6)
    Rook.create(game_id: id, x_position: 7, y_position: 7, color: 2, piece_type: 'rook', player_id: black_player_id, piece_number: 6)

    Knight.create(game_id: id, x_position: 1, y_position: 7, color: 2, piece_type: 'knight', player_id: black_player_id, piece_number: 7)
    Knight.create(game_id: id, x_position: 6, y_position: 7, color: 2, piece_type: 'knight', player_id: black_player_id, piece_number: 7)

    Bishop.create(game_id: id, x_position: 2, y_position: 7, color: 2, piece_type: 'bishop', player_id: black_player_id, piece_number: 8)
    Bishop.create(game_id: id, x_position: 5, y_position: 7, color: 2, piece_type: 'bishop', player_id: black_player_id, piece_number: 8)

    Queen.create(game_id: id, x_position: 3, y_position: 7, color: 2, piece_type: 'queen', player_id: black_player_id, piece_number: 9)
    King.create(game_id: id, x_position: 4, y_position: 7, color: 2, piece_type: 'king', player_id: black_player_id, piece_number: 10)
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


  # setStartBoard
  # Check 
  # Checkmate


  def check?(white)
    king = pieces_for_color(white).select { |piece| piece.piece_type == 'king' }.first
    return false unless king

    enemies = get_enemies(king)
    enemies.any? { |enemy| enemy.can_take?(king) }
  end

  def pieces_for_color(white)
    pieces.select { |piece| piece.white? == 1 } 
  end

  def checkmate?
    if @game.turn_number.even?
      @game.update(winning_player_id: @game.black_player_id)
    elsif game.turn_number.odd?
      @game.update(winning_player_id: @game.white_player_id)
    else
    return @game.determine_checkmate
    end
  end
end
