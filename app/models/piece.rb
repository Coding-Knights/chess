class Piece < ApplicationRecord
  belongs_to :game

  def occupiedCells
    occupiedCells = []
    game.pieces.each do |piece|
        occupiedCells << [piece.x_position, piece.y_position]
    end
    occupiedCells
  end


  def isObstructed? (game, endPos)
  # endPos = ending position from subclass piece, passed from subclass piece and is an array which includes current pos (x,y)
  # startPos = starting position, x & y from pieces DBschema
    startPos = [self.x_position, self.y_position]

  # this assigns instances to our x and y positions, grabs from specific position in array and converts each to integer. 
    @x1 = startPos[0].to_i
    @y1 = startPos[1].to_i
    @x2 = endPos[0].to_i
    @y2 = endPos[1].to_i

    @cellsToCheck = []

  # possible move? 
    if !((@x1 == @x2) || (@y1 == @y2) || (@x1-@x2).abs == (@y1-@y2).abs))
      return "Invalid. Not diagonal, horizontal, or vertical movement"
    elsif isVertObstructed?(startPos, endPos) || isHorizObstructed?(startPos, endPos) || isDiagObstructed?(startPos,endPos)
      return true
    else
      return false
    end
  end

  def checkCells
    (@cellsToCheck & occupiedCells).length > 0     
  end

  def isVertObstructed?(startPos,endPos)
    if @x1 == @x2 

    
  end

  def isHorizObstructed?(startPos,endPos)
    
  end

  def isDiagObstructed?(startPos,endPos)
    
  end
end