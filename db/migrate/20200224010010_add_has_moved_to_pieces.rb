class AddHasMovedToPieces < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :HasMoved, :boolean
  end
end
