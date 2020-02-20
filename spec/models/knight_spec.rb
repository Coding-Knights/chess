require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe 'valid_move? for the knight' do
    before(:each) do
      @knight = FactoryBot.create(:knight, x_position: '4', y_position: '4')
    end

    it 'should test if knight can go left 2, up 1' do 
      expect(@knight.valid_move?(2,5)).to eq true
    end

    it 'should test if knight can go left 1, up 2' do 
      expect(@knight.valid_move?(3,6)).to eq true
    end

    it 'should test if knight can go right 1, up 2' do 
      expect(@knight.valid_move?(5,6)).to eq true
    end

    it 'should test if knight can go right 2, up 1' do 
      expect(@knight.valid_move?(6,5)).to eq true
    end

    it 'should test if knight can go left 2, down 1' do 
      expect(@knight.valid_move?(2,3)).to eq true
    end

    it 'should test if knight can go left 1, down 2' do 
      expect(@knight.valid_move?(3,2)).to eq true
    end

    it 'should test if knight can go right 1, down 2' do 
      expect(@knight.valid_move?(5,2)).to eq true
    end

    it 'should test if knight can go right 2, down 1' do 
      expect(@knight.valid_move?(6,3)).to eq true
    end

    it 'should test if knight makes an illegal move' do 
      expect(@knight.valid_move?(7,4)).to eq true  
    end
  end
end


