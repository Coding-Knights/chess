class DropBlackWhiteFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :white_player_id
    remove_column :users, :black_player_id
  end
end
