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

ActiveRecord::Schema.define(version: 2020_02_24_033926) do
master

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "captured_pieces", force: :cascade do |t|
    t.integer "piece_id"
    t.integer "user_id"
    t.integer "current_player"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
