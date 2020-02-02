class Piece < ApplicationRecord
  belongs_to :game

  def occupiedCells
    occupiedCells = []                                          # creates empty array to store each pieces' coordinates
    game.pieces.each do |piece|                                 # iterating thru each games pieces with enumerator 'piece'
        occupiedCells << [piece.x_position, piece.y_position]   # store each pieces x/y data in array we created above 
    end
    occupiedCells               ####### ask mentor why exactly we need this line again ########
  end

# beginning of isObstructed? method
  def isObstructed? (game, endPos)
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
    if !((@x1 == @x2) || (@y1 == @y2) || (@x1-@x2).abs == (@y1-@y2).abs))
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
    if @x1 == @x2
      @y1 , @y2 = @y2 , @y1 if @y1 > @y2
      (@y1 + 1...@y2).each do |y|
        @cellsToCheck << [@x1, y]
      end
    end
  end

  def isHorizObstructed?(startPos,endPos)
    
  end

  def isDiagObstructed?(startPos,endPos)
    
  end
end