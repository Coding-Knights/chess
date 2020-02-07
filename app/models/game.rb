class Game < ApplicationRecord
  has_many :pieces
  has_many :users

  scope :available, -> { where(black_player_id:  nil)}
  
  after_create :populate_game!
  def populate_game!
    # White Pieces
    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x_position: i,
        y_position: 1,
        color: 1
        )
    end

    Rook.create(game_id: id, x_position: 0, y_position: 0, color: 1)
    Rook.create(game_id: id, x_position: 7, y_position: 0, color: 1)

    Knight.create(game_id: id, x_position: 1, y_position: 0, color: 1)
    Knight.create(game_id: id, x_position: 6, y_position: 0, color: 1)

    Bishop.create(game_id: id, x_position: 2, y_position: 0, color: 1)
    Bishop.create(game_id: id, x_position: 5, y_position: 0, color: 1)

    Queen.create(game_id: id, x_position: 3, y_position: 0, color: 1)
    King.create(game_id: id, x_position: 4, y_position: 0, color: 1)

    # Black Pieces
    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x_position: i,
        y_position: 6,
        color: 2
        )
    end

    Rook.create(game_id: id, x_position: 0, y_position: 7, color: 2)
    Rook.create(game_id: id, x_position: 7, y_position: 7, color: 2)

    Knight.create(game_id: id, x_position: 1, y_position: 7, color: 2)
    Knight.create(game_id: id, x_position: 6, y_position: 7, color: 2)

    Bishop.create(game_id: id, x_position: 2, y_position: 7, color: 2)
    Bishop.create(game_id: id, x_position: 5, y_position: 7, color: 2)

    Queen.create(game_id: id, x_position: 3, y_position: 7, color: 2)
    King.create(game_id: id, x_position: 4, y_position: 7, color: 2)
  end
end
