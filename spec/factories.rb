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
end