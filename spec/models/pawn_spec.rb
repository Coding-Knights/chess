require 'rails_helper'

RSpec.describe Pawn, type: :model do
  # normal bishop movement test
  it 'should test if PAWN can move 2 spaces on initial move' do 
    Game.skip_callback(:create, :after, :populate_game!, raise: false)
    game = FactoryBot.create(:game)
    @bishop = FactoryBot.create(:bishop, x_position: '0', y_position: '0', game_id: game.id)
    expect(@bishop.valid_move?(7,7)).to eq true
  end

  it 'should test if PAWN cannot move 2 spaces after first move' do

  end 

  it 'should test if PAWN can move 1 space at a time' do

  end

  it 'should test if PAWN isObstructed when attempting to move passed existing piece' do 

  end

  it 'should test if PAWN can capture diagonally' do 

  end 

end