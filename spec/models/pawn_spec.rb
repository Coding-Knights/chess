require 'rails_helper'

RSpec.describe Pawn, type: :model do
  
  it 'should test if WHITE PAWN can move 2 spaces on initial move' do 
    @white_pawn = FactoryBot.create(:pawn, x_position: '3', y_position: '1', color: 1)
    expect(@white_pawn.valid_move?(3,3)).to eq true
  end

  it 'should test if BLACK PAWN can move 2 spaces on initial move' do 
    @black_pawn = FactoryBot.create(:pawn, x_position: '3', y_position: '6', color: 2)
    expect(@black_pawn.valid_move?(3,4)).to eq true
  end

  it 'should test if WHITE PAWN cannot move backwards(reverse)' do
    @white_pawn = FactoryBot.create(:pawn, x_position: '3', y_position: '6', color: 1)
    expect(@white_pawn.valid_move?(3,5)).to eq false
  end

  it 'should test if BLACK PAWN cannot move backwards(reverse)' do
    @black_pawn = FactoryBot.create(:pawn, x_position: '3', y_position: '2', color: 2)
    expect(@black_pawn.valid_move?(3,3)).to eq false
  end

 
  it 'should test if PAWN cannot move 2 spaces after first move' do
    @pawn = FactoryBot.create(:pawn, x_position: '4', y_position: '4')
    expect(@pawn.valid_move?(4,6)).to eq false
  end 


  it 'should test if PAWN can move 1 space at a time' do
    @pawn = FactoryBot.create(:pawn, x_position: '4', y_position: '4')
    expect(@pawn.valid_move?(4,5)).to eq true
  end

  it 'should test if PAWN isObstructed when attempting to move passed an existing piece' do 
    Game.skip_callback(:create, :after, :populate_game!, raise: false)
    game = FactoryBot.create(:game)
    @pawn = FactoryBot.create(:pawn, x_position: '4', y_position: '4', game_id: game.id)
    @pawn2 = FactoryBot.create(:pawn, x_position: '4', y_position: '5', game_id: game.id)
    expect(@pawn.valid_move?(4,5)).to eq false
  end

  it 'should test if PAWN can capture diagonally' do 
    Game.skip_callback(:create, :after, :populate_game!, raise: false)
    game = FactoryBot.create(:game)
    @pawn = FactoryBot.create(:pawn, x_position: '4', y_position: '4', game_id: game.id)
    @pawn2 = FactoryBot.create(:pawn, x_position: '5', y_position: '5', game_id: game.id)
    expect(@pawn.valid_move?(5,5)).to eq true
  end 
end

# Game.skip_callback(:create, :after, :populate_game!, raise: false)
# game = FactoryBot.create(:game)
# @bishop = FactoryBot.create(:bishop, x_position: '0', y_position: '0', game_id: game.id)
# expect(@bishop.valid_move?(7,7)).to eq true