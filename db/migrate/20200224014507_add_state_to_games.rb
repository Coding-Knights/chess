class AddStateToGames < ActiveRecord::Migration[5.2]
<<<<<<< Updated upstream
  def change
    add_column :games, :state, :string unless Game.column_names.include?('state')
  end
=======
  def self.up
    add_column :games, :state, :string unless Game.column_names.include?('state')
  end

    def self.down
    remove_column :games, :state, :string unless Game.column_names.include?('state')
  end
>>>>>>> Stashed changes
end
