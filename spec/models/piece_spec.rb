require 'rails_helper'


RSpec.describe Piece, type: :model do
	# it 'prevents putting yourself in check' do
	# 	user = FactoryBot.create(:user)
	# 	game = FactoryBot.create(:game, white_player_id: user.id)
	# 	king = FactoryBot.create(:king, piece_number: 4, x_position: 3, y_position: 3, game_id: game.id, type: 'king')
	# 	rook = FactoryBot.create(:rook, piece_number: 11, x_position: 4, y_position: 4, game_id: game.id, type: 'rook')
	# 	puts king.inspect
	# 	puts rook.inspect
		
  
	# 	expect(king.puts_self_in_check?(3,4)).to eq true
	# end

	it 'prevents putting yourself in check' do
		game = FactoryBot.create(:game)
		king = FactoryBot.create(:king, piece_number: 4, x_position: 3, y_position: 3, game_id: game.id, color: 1)
		FactoryBot.create(:rook, piece_number: 11, x_position: 4, y_position: 4, game_id: game.id, color: 2)
  
		expect(king.puts_self_in_check?(3, 4)).to eq true
		expect(king.puts_self_in_check?(2, 2)).to eq false
	  end
end

# RSpec.describe Game, type: :model do
# 	it "should check if pawn at (3,1) exists" do
# 		## chris + Vincent wrote this; TODO factorybot the model properly

# 		# kibi added stuff here
# 		Game.set_callback(:create, :after, :populate_game!, raise: false)
# 		board = FactoryBot.create(:game)
# 		@pawn = board.pieces.where(x_position: '3', y_position: '1')

# 		expect(@pawn).not_to be_empty
# 	end

# 	it "should have all pieces in game initially" do

# 		# kibi added stuff here
# 		Game.set_callback(:create, :after, :populate_game!, raise: false)
# 		board = FactoryBot.create(:game)
# 		pieces = board.pieces.where(y_position: '0', y_position: '1', y_position: '6', y_position: '7')

# 		expect(pieces).not_to be_empty
# 	end
# end

#  Game.find(1).pieces.where(x_position: '0', y_position: '1')
