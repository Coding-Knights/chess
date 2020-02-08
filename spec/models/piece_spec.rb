require 'rails_helper'


RSpec.describe Piece, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

RSpec.describe Game, type: :model do
	it "should retrieve a piece from the board" do
		## chris + Vincent wrote this; TODO factorybot the model properly
		board = Game.new
		pawn = Pawn.new
		pawn.x_position = 1
		pawn.y_position = 1
		board.pieces << pawn

		expect(board.getPieceAt(1, 1)).toBe(pawn)
	end
end