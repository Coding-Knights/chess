class AddStateToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :state, :string unless Game.column_names.include?('state')
  end
end
