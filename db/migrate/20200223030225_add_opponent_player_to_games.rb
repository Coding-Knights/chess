class AddOpponentPlayerToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :opponent_player, :string
  end
end
