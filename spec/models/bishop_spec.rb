require 'rails_helper'

RSpec.describe Bishop, type: :model do
  # normal bishop movement test
  it 'should test if bishop can move diagonally' do 
    Game.skip_callback(:create, :after, :populate_game!, raise: false)
    game = FactoryBot.create(:game)
    @bishop = FactoryBot.create(:bishop, x_position: '0', y_position: '0', game_id: game.id)
    expect(@bishop.valid_move?(7,7)).to eq true
  end

  # test to see if bishop will return false when given a coordinate off the board
  it 'should test if bishop will stay on board' do
    @bishop = FactoryBot.create(:bishop, x_position: '0', y_position: '0')
    expect(@bishop.valid_move?(-10,-10)).to eq false
  end

  # test if bishop can be obstructed by another piece
  it 'should test if bishop cannot move passed another piece' do
    Game.skip_callback(:create, :after, :populate_game!, raise: false)
    game = FactoryBot.create(:game)
    @bishop = FactoryBot.create(:bishop, x_position: '0', y_position: '0', game_id: game.id)
    @bishop2 = FactoryBot.create(:bishop, x_position: '3', y_position: '3', game_id: game.id)
    expect(@bishop.valid_move?(7,7)).to eq false
  end

  # add capture move 

end