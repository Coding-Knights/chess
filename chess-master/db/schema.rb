# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_02_054614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "white_player_id"
    t.integer "black_player_id"
    t.integer "winner_id"
    t.integer "loser_id"
    t.integer "game_id"
    t.string "opponent_player"
    t.string "state"
    t.integer "turn_number"
  end

  create_table "moves", force: :cascade do |t|
    t.integer "game_id"
    t.integer "user_id"
    t.integer "start_piece", limit: 2
    t.integer "end_piece", limit: 2
    t.integer "start_x", limit: 2
    t.integer "start_y", limit: 2
    t.integer "final_x", limit: 2
    t.integer "final_y", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "piece_id"
    t.index ["final_x", "final_y"], name: "index_moves_on_final_x_and_final_y"
    t.index ["game_id"], name: "index_moves_on_game_id"
    t.index ["piece_id"], name: "index_moves_on_piece_id"
    t.index ["start_piece"], name: "index_moves_on_start_piece"
    t.index ["start_x", "start_y"], name: "index_moves_on_start_x_and_start_y"
    t.index ["user_id"], name: "index_moves_on_user_id"
  end

  create_table "pieces", force: :cascade do |t|
    t.integer "x_position"
    t.integer "y_position"
    t.string "piece_type"
    t.integer "player_id"
    t.integer "game_id"
    t.integer "captured_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "color"
    t.boolean "HasMoved"
    t.integer "piece_number"
    t.string "type"
    t.index ["game_id"], name: "index_pieces_on_game_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.text "image"
    t.bigint "white_player_id"
    t.bigint "black_player_id"
    t.index ["black_player_id"], name: "index_users_on_black_player_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["white_player_id"], name: "index_users_on_white_player_id"
  end

  add_foreign_key "users", "games", column: "black_player_id"
  add_foreign_key "users", "games", column: "white_player_id"
end
