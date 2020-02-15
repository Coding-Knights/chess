require 'rails_helper'


RSpec.describe Piece, type: :model do
end

RSpec.describe Game, type: :model do
end

RSpec.describe King, type: :model do
  it "should check if king at (4,0) exists" do
    board = FactoryBot.create(:game)
    king = board.pieces.where(x_position: '4', y_position: '0')

    expect(king).not_to be_empty
  end

  it 'should test if horizontal moves are valid' do      
    expect(@king.valid_move?(5, 0)).to eq true
  end

  it 'should not allow horizontal movements greater than 1' do
    expect(@king.valid_move?(6, 0)).to eq false
  end  
end


