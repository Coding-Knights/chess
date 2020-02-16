FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password {"secretPassword"}
    password_confirmation {"secretPassword"}
  end

  factory :game do 
  	name {"test"}
  	association :white_player_id, factory: :user
  	association :black_player_id, factory: :user
  end

  factory :piece do
    x_position { 1 }
    y_position { 1 }

    association :game
  end

  factory :king, parent: :piece, class: 'King' do        
  end

  factory :queen, parent: :piece, class: 'Queen' do
  end

  factory :bishop, parent: :piece, class: 'Bishop' do    
  end

  factory :knight, parent: :piece, class: 'Knight' do
  end

  factory :rook, parent: :piece, class: 'Rook' do
  end

  factory :pawn, parent: :piece, class: 'Pawn' do
  end
end