class Piece < ApplicationRecord
  belongs_to :game
  has_many :moves, dependent: :destroy

  def occupiedCells 
    occupiedCells = []                                          # creates empty array to store each pieces' coordinates
    game.pieces.each do |piece|                                 # iterating thru each games pieces with enumerator 'piece'
        occupiedCells << [piece.x_position, piece.y_position]   # store each pieces x/y data in array we created above 
    end
    occupiedCells   ####################### ask mentor why exactly we need this line again ########################
  end


  def isObstructed?(x, y)
    x_sorted_array = [x, x_position].sort
    y_sorted_array = [y, y_position].sort

    if players_own_piece_is_there?(x, y)
      return true
    elsif y - y_position == 0 then
      return horizontal_obstruction?(x, y, x_sorted_array, y_sorted_array)
    elsif x - x_position == 0 then
      return vertical_obstruction?(x, y, x_sorted_array, y_sorted_array)
    elsif (x - x_position).abs == (y - y_position).abs then
      return diagonal_obstruction?(x, y, x_sorted_array, y_sorted_array)
    else
      return true
    end
  end

  def horizontal_obstruction?(x, y, x_sorted_array, y_sorted_array)
    obstructions = game.pieces.find do |chess_piece|
      is_on_same_rank = y == chess_piece.y_position
      is_between_x = chess_piece.x_position.between?(x_sorted_array[0] + 1, x_sorted_array[1] - 1)
      is_on_same_rank && is_between_x
    end
    return obstructions.present?
  end

  def vertical_obstruction?(x, y, x_sorted_array, y_sorted_array)
    obstructions = game.pieces.find do |chess_piece|
      is_on_same_file = x == chess_piece.x_position
      is_between_y = chess_piece.y_position.between?(y_sorted_array[0] + 1, y_sorted_array[1] - 1)
      is_on_same_file && is_between_y
    end
    return obstructions.present?
  end

  def diagonal_obstruction?(x, y, x_sorted_array, y_sorted_array)
    obstructions = game.pieces.find do |chess_piece|
      is_eq_abs = (x - chess_piece.x_position).abs == (y - chess_piece.y_position).abs
      is_between_x = chess_piece.x_position.between?(x_sorted_array[0] + 1, x_sorted_array[1] - 1)
      is_between_y = chess_piece.y_position.between?(y_sorted_array[0] + 1, y_sorted_array[1] - 1)

      is_eq_abs && is_between_x && is_between_y
    end
    return obstructions.present?
  end


  def is_on_board?(x,y)
    # is bounded by the dimensions of the board
    if (0..7).include?(x.to_i) && (0..7).include?(y.to_i)
      return true
    else
      return false
    end
  end

  def players_own_piece_is_there?(x, y)
    occupying_piece = Piece.where(x_position: x, y_position: y, game_id: game.id)
    if occupying_piece.any? then
      return occupying_piece.first.is_white? == is_white?
    else
      false
    end
  end

  def move_to!(x, y)
    occupying_piece = Piece.where(x_position: x, y_position: y, game_id: game.id)
    occupying_piece.first&.captured!

    if type == 'Pawn'
      last_piece_moved = game.pieces.order('updated_at').last

      if en_passant?(x, y) then
        last_piece_moved.captured!
      end
    end

    create_move(x, y)
    assign_attributes(x_position: x, y_position: y, HasMoved: true)
    save
  end

  def en_passant?(x, y)
    last_move = game.pieces.order('updated_at').last.moves.order('updated_at').last
    return false if last_move.nil?
    return true  if pawn_moved_through_capture(x, y, last_move)
    return false
  end

  def pawn_moved_through_capture(x, y, last_move)
    pawn_moved_two = (last_move.start_y - last_move.final_y).abs == 2
    if last_move.start_piece == 5 && piece_number == 11 # White pawn moved past black pawn
      return pawn_moved_two && x == last_move.final_x && y == 2
    elsif last_move.start_piece == 11 && piece_number == 5# Black pawn moved past white pawn
      return pawn_moved_two && x == last_move.final_x && y == 5
    else
      return false
    end
  end

  def captured!
    if is_white?
      assign_attributes(x_position: -1, y_position: -1) 
    else #basically if its black
      assign_attributes(x_position: -2, y_position: -2)
    end 
    save
  end

  def create_move(x, y)
    moves.create(game_id: game.id, user_id: player_id, start_piece: piece_number, start_x: x_position, start_y: y_position, final_x: x, final_y: y)
  end

  def can_take?(piece)
    return if piece == nil

    valid_move?(piece.x_position, piece.y_position) && 
      (is_white? != piece.is_white?)
  end

  def puts_self_in_check?(x, y)
    previous_attributes = attributes
    begin
      enemy = get_piece(x, y, game)
      if enemy.present?
        enemy_attributes = enemy.attributes
        enemy.update(x_position: 100, y_position: 100)
      end
      update(x_position: x, y_position: y)
      game.pieces.reload
      game.check?(is_white?)
    ensure
      enemy&.update(enemy_attributes)
      update(previous_attributes)
      game.pieces.reload
    end
  end

  def puts_enemy_in_check?(x, y)
    previous_attributes = attributes
    begin
      update(x_position: x, y_position: y)
      game.pieces.reload
      game.check?(!is_white?)
    ensure
      update(previous_attributes)
      game.pieces.reload
    end
  end

  def get_piece(x, y, game)
    game.pieces.where(x_position: x, y_position: y).first
  end

  # def valid_move?(x,y)
  #   # needs to set up for duck typing
  # end


  # def is_in_check?(x = self.x_position, y = self.y_position)
  #   self.game.pieces.each do |enemy|
  #     if enemy.color != self.color && enemy.valid_move?(x,y)
  #       return true
  #     end
  #   end
  #   return false
  # end 

  
  
  def can_castle?(rook)
    x_sorted_array = [rook.x_position, x_position].sort
    y_sorted_array = [rook.y_position, y_position].sort

    if !players_turn_and_pieces?(rook) ||
       HasMoved? ||
       game.pieces.where(x_position: rook.x_position, y_position: rook.y_position).first.HasMoved? ||
       horizontal_obstruction?(rook.x_position, rook.y_position, x_sorted_array, y_sorted_array) ||
       opponent_pieces.any? { |piece| piece.can_take?(self) } ||
       rook.x_position == 0 && [1, 2].any? { |number| moves_into_check?(x_position - number, y_position) } ||
       rook.x_position == 7 && [1, 2].any? { |number| moves_into_check?(x_position + number, y_position) }
      return false
      # come back to this code later
    end

    return true
  end

  def moves_into_check?(x, y)
    return opponent_pieces.any? { |piece| piece.valid_move?(x, y) }
  end

  def players_turn_and_pieces?(rook)
    last_piece_moved = game.pieces.order('updated_at').last.moves.order('updated_at').last
    if last_piece_moved.present?
      last_piece_moved_was_black = last_piece_moved.start_piece > 5
      return last_piece_moved_was_black && is_white? && rook.is_white? || !last_piece_moved_was_black && !is_white? && !rook.is_white?
    end
    return false
  end   

  def opponent_pieces
    if is_white?
      game.pieces.where('piece_number > 5')
    else
      game.pieces.where('piece_number < 6')
    end
  end

  def castle!(rook)
    if is_white? and rook.x_position == 0
      rook.create_move(3, 0)
      rook.assign_attributes(x_position: 3, HasMoved: true)
      rook.save
      create_move(2, 0)
      assign_attributes(x_position: 2, HasMoved: true)
      save
    elsif is_white? and rook.x_position == 7
      rook.create_move(5, 0)
      rook.assign_attributes(x_position: 5, HasMoved: true)
      rook.save
      create_move(6, 0)
      assign_attributes(x_position: 6, HasMoved: true)
      save
    elsif !is_white? and rook.x_position == 0
      rook.create_move(3, 7)
      rook.assign_attributes(x_position: 3, HasMoved: true)
      rook.save
      create_move(2, 7)
      assign_attributes(x_position: 2, HasMoved: true)
      save 
    else
      rook.create_move(5, 7)
      rook.assign_attributes(x_position: 5, HasMoved: true)
      rook.save
      create_move(6, 7)
      assign_attributes(x_position: 6, HasMoved: true)
      save
    end
  end
end