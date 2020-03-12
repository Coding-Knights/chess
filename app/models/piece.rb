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


  def isObstructed? (game, endPos) # endPos looks like this -> [x, y]
  # game = game id with all the pieces that were created?
  # endPos = ending position from subclass piece, passed from subclass piece and is an array which includes current pos (x,y)
  # startPos = starting position, x & y from pieces DBschema
    startPos = [self.x_position, self.y_position]

  # this assigns instances to our x and y positions, grabs from specific position in array and converts each to integer. 
    @x1 = startPos[0].to_i # this will grab the 0 position element from startPos and convert it to an integer
    @y1 = startPos[1].to_i # same as above but with 1 position element 
    @x2 = endPos[0].to_i   # same as line 20 but with the endPos argument
    @y2 = endPos[1].to_i   # same as line 21 but with endPos

    @cellsToCheck = [] # creating a new array that will store cells needed to check 

  # start of if statement that will call on other methods within scope of isObstructed? method
    if players_own_piece_is_there?(@x2, @y2)
      return true
    elsif ((@x1 == @x2) && (@y1 == @y2))
      return "Invalid. Not diagonal, horizontal, or vertical movement"
    elsif isVertObstructed?(startPos, endPos) || isHorizObstructed?(startPos, endPos) || isDiagObstructed?(startPos,endPos)
      return true
    else
      return false
    end
  end

  # check the intersection of the 2 arrays cellsToCheck and occupiedCells 
  def checkCells
    (@cellsToCheck & occupiedCells).length > 0     
  end

  def isVertObstructed?(startPos,endPos)
    if @x1 == @x2 # x stayed the same for both start and end positions, only changing y, traversing vertically
      @y1 , @y2 = @y2 , @y1 if @y1 > @y2 # this switch is needed in order to keep the coordinates in the right scope, if that makes sense
      (@y1 + 1...@y2).each do |y|
        @cellsToCheck << [@x1, y]
      end
    checkCells # run checkCells method, if greater than 0 return true, meaning path is obstructed
    end
  end

  def isHorizObstructed?(startPos,endPos)
    if @y1 == @y2 # y stayed the same, we are traversing horizontally
      @x1 , @x2 = @x2 , @x1 if @x1 > @x2 # we need this code, same reason on line 44
      (@x1 + 1...@y2).each do |x|
        @cellsToCheck << [x, @y1]
      end
    checkCells
    end 
  end

  #castling horizontal obstruction
  def horizontal_obstruction?(x, y, x_sorted_array, y_sorted_array)
    obstructions = game.pieces.find do |chess_piece|
      is_on_same_rank = y == chess_piece.y_position
      is_between_x = chess_piece.x_position.between?(x_sorted_array[0] + 1, x_sorted_array[1] - 1)
      is_on_same_rank && is_between_x
    end
    return obstructions.present?
  end

  def isDiagObstructed?(startPos,endPos) # example case use [5,1] -> [2,4]
    x1, y1 = @x1, @y1 # [5 , 1]
    x2, y2 = @x2, @y2 # [2 , 4]

    if (@x1-@x2).abs == (@y1-@y2).abs
      @x1 , @x2 = @x2 , @x1 if @x1 > @x2 # this is to keep coordinates in check                       -> switches @x1 with @x2
      @y1 , @y2 = @y2 , @y1 if @y1 > @y2

      x_ary = (@x1 + 1...@x2).to_a # creating an array with x values that are between @x1 & @x2       -> [3 , 4]
      y_ary = (@y1 + 1...@y2).to_a # same as above but with y, @y1 & @y2                              -> [2 , 3]

      if x1 > x2 && y1 < y2 # example case ends up here 
        x_ary.reverse! # [3 , 4] reverses to [4 , 3]
        @cellsToCheck = x_ary.zip(y_ary) # stores coordinates: (4,2) & (3,3) in @cellsToCheck, then does checkCells method
      elsif x1 < x2 && y1 > y2
        y_ary.reverse!
        @cellsToCheck = x_ary.zip(y_ary) 
      else 
        @cellsToCheck = x_ary.zip(y_ary) 
      end
    checkCells
    end
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