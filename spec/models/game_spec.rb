require 'rails_helper'

RSpec.describe Game, type: :model do
	it "should check if correct player can move" do
		Game.set_callback(:create, :after, :populate_game!, raise: false)
        user1 = FactoryBot.create(:user)
        board = user1.FactoryBot.create(:game)
        user2 = FactoryBot.create(:user)
        board.update_attributes(white_player_id: user1.id, black_player_id: user2.id, turn_number: 0)
        @blackpawn = board.pieces.find_by(x_position: '0', y_position: '6')
		expect(@blackpawn.move_to!(0,5)).to eq false
	end

end

