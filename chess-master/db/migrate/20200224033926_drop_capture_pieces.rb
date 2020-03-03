class DropCapturePieces < ActiveRecord::Migration[5.2]
  def change
  	drop_table :capture_pieces
  end
end
