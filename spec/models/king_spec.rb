require 'rails_helper'


RSpec.describe Piece, type: :model do
end

RSpec.describe Game, type: :model do
end

RSpec.describe King, type: :model do
  it 'should check if vertical moves are valid' do
    @king = FactoryBot.create(:king, x_position: '4', y_position: '4')
    expect(@king.valid_move?(4,5)).to eq true
  end

  it 'should check if horizontal moves are valid' do
    @king = FactoryBot.create(:king, x_position: '4', y_position: '4')
    expect(@king.valid_move?(5,4)).to eq true
  end

  it 'should test if diagonal moves are valid' do
    @king = FactoryBot.create(:king, x_position: '4', y_position: '4')
    expect(@king.valid_move?(5,5)).to eq true
  end

  it 'should not allow horizontal movements greater than 1' do
    @king = FactoryBot.create(:king, x_position: '4', y_position: '4')
    expect(@king.valid_move?(6, 4)).to eq false
  end

  it 'should not allow vertical movements greater than 1' do
    @king = FactoryBot.create(:king, x_position: '4', y_position: '4')
    expect(@king.valid_move?(4, 6)).to eq false
  end 

  it 'should not allow diagonal movements greater than 1' do
    @king = FactoryBot.create(:king, x_position: '4', y_position: '4')
    expect(@king.valid_move?(6, 6)).to eq false
  end

  it 'should not allow move to original location' do
    @king = FactoryBot.create(:king, x_position: '4', y_position: '4')
    expect(@king.valid_move?(4, 4)).to eq false
  end   
end


