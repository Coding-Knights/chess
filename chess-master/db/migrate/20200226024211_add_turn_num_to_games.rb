class AddTurnNumToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :turn_number, :integer
  end
end
