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

# beginning of isObstructed? method
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
    if !((@x1 == @x2) || (@y1 == @y2) || (@x1-@x2).abs == (@y1-@y2).abs)
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

  def move_to!(x, y)
    occupying_piece = Piece.where(x_position: x, y_position: y, game_id: game.id)
    occupying_piece.first&.captured!

    # if type == 'Pawn'
    #   last_piece_moved = game.pieces.order('updated_at').last

    #   if en_passant?(x, y) then
    #     last_piece_moved.set_captured!
    #   end
    # end

    create_move(x, y)
    assign_attributes(x_position: x, y_position: y, HasMoved: true)
    save
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
    piece = self 
    begin
      enemy = get_piece(x, y, game)
      if enemy.present?
        enemy_attributes = enemy.attributes
        enemy.update(x_position: 100, y_position: 100) # possibly add black/white if statements to place enemy

      end
      update(x_position: x, y_position: y)
      game.pieces.reload
      if piece.type == 'King'
        piece.is_in_check?(x,y)
      end
    ensure
      enemy&.update(enemy_attributes)
      update(previous_attributes)
      game.pieces.reload
    end
  end

  def puts_enemy_in_check?(x, y)
    previous_attributes = attributes
    piece = self
    begin
      update(x_position: x, y_position: y)
      game.pieces.reload
      piece.is_in_check?(x,y)
    ensure
      update(previous_attributes)
      game.pieces.reload
    end
  end

  def get_piece(x, y, game)
    game.pieces.where(x_position: x, y_position: y).first
  end

  def valid_move?(x,y)
    # needs to set up for duck typing
  end


  def is_in_check?(x = self.x_position, y = self.y_position)
    self.game.pieces.each do |enemy|
      if enemy.color != self.color && enemy.valid_move?(x,y)
        return true
      end
    end
    return false
  end 

  def can_castle?(x, y)
      piece = Piece.find_by(x_position: x, y_position: y, game_id: game_id, user_id: user_id)
      if piece.type == "King" && !moved && piece.type == "Rook" && !piece.moved && IsObstructed 
        return false
      else  
        return true
    end
  end
      #return false if king_in_check
      #return false it king has moved
      #return false if rook has moved
      #return false if self is_obstructed rook position

      #for all of the steps between rook and the self position return false if any step is in_check

  def castle!(rook_position)
    #return false unless self can castle rook position
    #save self position
    #put self at rook position
    #move rook to self position
    if is_white? && rook_position.y_position == 0
      rook_position.create_move(0, 3)
      rook_position.assign_attributes(y_position: 3, moved: true)
      rook_position.save
      create_move(0, 2)
      assign_attributes(y_position: 2, moved: true)
      save
    elsif is_white? && rook_position.y_position == 7
      rook_position.create_move(0, 5)
      rook_position.assign_attributes(y_position: 5, moved: true)
      rook_position.save
      create_move(0, 6)
      assign_attributes(y_position: 6, moved: true)
      save
    elsif !is_white? && rook_position.y_position == 0
      rook_position.create_move(7, 3)
      rook_position.assign_attributes(y_position: 3, moved: true)
      rook_position.save
      create_move(7, 2)
      assign_attributes(y_position: 2, moved: true)
      save
    else
      rook_position.create_move(7, 5)
      rook_position.assign_attributes(y_position: 5, moved: true)
      rook_position.save
      create_move(7, 6)
      assign_attributes(y_position: 6, moved: true)
      save
    end
  end    
end