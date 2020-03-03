require 'rails_helper'

# RSpec.describe 'Castling in a Game', type: :feature do
#   feature 'pieces#castle' do
#     before(:each) do
#       @white_player_id = create(:user)
#       @black_player_id = create(:user)
#       @game = create(:game, name: 'Testerroni Pizza',
#         white_player_id: @white_player_id, black_player_id: @black_player_id,
#         creating_user_id: @white_player_id, invited_user_id: @black_player_id)

#       @white_king = create(:king, x_position: 0, y_position: 4, game_id: @game.id)
#       @white_queenside_rook = create(:rook, x_position: 0, y_position: 0, game_id: @game.id)
#       @white_kingside_rook = create(:rook, x_position: 0, y_position: 7, game_id: @game.id)
#     end
#   end  

#     scenario 'White player queen side castles' do
#       black_pawn = create(:pawn, x_position: 6, y_position: 2, piece_number: 11, game_id: @game.id)
#       move = create(:move, game_id: @game.id, piece_id: black_pawn.id, start_piece: 11)

#       sign_in @white_player_id
#       visit game_path(@game)
#       expect(page).to have_content 'White Queen Side Castle'
#     end
# end    