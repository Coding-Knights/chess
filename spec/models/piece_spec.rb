require 'rails_helper'


RSpec.describe Piece, type: :model do
end

RSpec.describe Game, type: :model do
	it "should check if pawn at (3,1) exists" do
		## chris + Vincent wrote this; TODO factorybot the model properly

		# kibi added stuff here
		Game.set_callback(:create, :after, :populate_game!, raise: false)
		board = FactoryBot.create(:game)
		@pawn = board.pieces.where(x_position: '3', y_position: '1')

		expect(@pawn).not_to be_empty
	end

	it "should have all pieces in game initially" do

		# kibi added stuff here
		Game.set_callback(:create, :after, :populate_game!, raise: false)
		board = FactoryBot.create(:game)
		pieces = board.pieces.where(y_position: '0', y_position: '1', y_position: '6', y_position: '7')

		expect(pieces).not_to be_empty
	end
end

#  Game.find(1).pieces.where(x_position: '0', y_position: '1')
