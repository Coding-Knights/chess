require 'rails_helper'

RSpec.describe Game, type: :model do
    it 'returns true if the black king is in checkmate' do
        @game = FactoryBot.create(:game, white_player_id: 1, black_player_id: 2)
        @black_king = FactoryBot.create(:king, x_position: 4, y_position: 4, game_id: @game.id, piece_number: 10)
        white_queen = FactoryBot.create(:queen, x_position: 3, y_position: 3, game_id: @game.id, piece_number: 3)
        white_rook1 = FactoryBot.create(:rook, x_position: 3, y_position: 2, game_id: @game.id, piece_number: 0)
        white_rook2 = FactoryBot.create(:rook, x_position: 5, y_position: 6, game_id: @game.id, piece_number: 0)
        white_rook3 = FactoryBot.create(:rook, x_position: 2, y_position: 3, game_id: @game.id, piece_number: 0)
        white_rook4 = FactoryBot.create(:rook, x_position: 6, y_position: 5, game_id: @game.id, piece_number: 0)
        
        puts @game.inspect


        expect(@game.checkmate?(@black_king.is_white?)).to eq true
      end
end