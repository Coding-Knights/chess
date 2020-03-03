class DropCapturedTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :captured_pieces
  end
end
