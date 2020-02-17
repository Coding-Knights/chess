require 'rails_helper'

RSpec.describe Queen, type: :model do

  it 'should check if diagonal moves are valid' do
    @queen = FactoryBot.create(:queen, x_position: '4', y_position: '4')
    expect(@queen.valid_move?(5,5)).to eq true
  end

  it 'should check if vertical moves are valid' do
    @queen = FactoryBot.create(:queen, x_position: '0', y_position: '0')
    expect(@queen.valid_move?(0,1)).to eq true
  end

  it 'should check if horizontal moves are valid' do
    @queen = FactoryBot.create(:queen, x_position: '4', y_position: '4')
    expect(@queen.valid_move?(4,5)).to eq true
  end

  it 'should check if queen cannot go off board' do
    @queen = FactoryBot.create(:queen, x_position: '4', y_position: '4')
    expect(@queen.valid_move?(10,10)).to eq false
  end

  it 'should test if bishop cannot move passed another piece' do
    Game.skip_callback(:create, :after, :populate_game!, raise: false)
    game = FactoryBot.create(:game)
    @queen = FactoryBot.create(:queen, x_position: '4', y_position: '4', game_id: game.id)
    @queen2 = FactoryBot.create(:queen, x_position: '4', y_position: '3', game_id: game.id)
    expect(@queen.valid_move?(4,2)).to eq false
  end
  
end