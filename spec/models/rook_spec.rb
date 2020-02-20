require 'rails_helper'

RSpec.describe Rook, type: :model do
  it 'should check if vertical moves are valid' do
    @rook = FactoryBot.create(:rook, x_position: '0', y_position: '0')
    expect(@rook.valid_move?(0,1)).to eq true
  end

  it 'should check if horizontal moves are valid' do
    @rook = FactoryBot.create(:rook, x_position: '4', y_position: '4')
    expect(@rook.valid_move?(4,5)).to eq true
  end

   it 'should check if diagonal moves are valid' do
    @rook = FactoryBot.create(:rook, x_position: '4', y_position: '4')
    expect(@rook.valid_move?(5,5)).to eq false
  end

  it 'should check if rook moving off board is invalid' do
    @rook = FactoryBot.create(:rook, x_position: '0', y_position: '0')
    expect(@rook.valid_move?(0,10)).to eq false
  end

  it 'should check if rook moves illegally on the board' do 
    @rook = FactoryBot.create(:rook, x_position: '3', y_position: '3')
    expect(@rook.valid_move?(3,3)).to eq false 
  end 
    
  end

  it 'should not be able to move passed another piece isObstructed' do
    Game.skip_callback(:create, :after, :populate_game!, raise: false)
    game = FactoryBot.create(:game)
  	@rook = FactoryBot.create(:rook, x_position: '4', y_position: '4', game_id: game.id)
  	@rook2 = FactoryBot.create(:rook, x_position: '4', y_position: '3', game_id: game.id)
  	expect(@rook.valid_move?(4,2)).to eq false
  end
end  