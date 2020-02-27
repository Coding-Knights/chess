class AddPiecenumToPieces < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :piece_number, :integer
  end
end
