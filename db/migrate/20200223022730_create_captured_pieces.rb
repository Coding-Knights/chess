class CreateCapturedPieces < ActiveRecord::Migration[5.2]
  def change
    create_table :captured_pieces do |t|
      t.integer "piece_id"
      t.integer "user_id"
      t.integer "current_player"
      t.timestamps
    end
  end
end
