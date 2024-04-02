# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_240_401_205_242) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'
  enable_extension 'timescaledb'
  enable_extension 'timescaledb_toolkit'

  create_table 'match_players', force: :cascade do |t|
    t.bigint 'player_id', null: false
    t.bigint 'match_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'points'
    t.index ['match_id'], name: 'index_match_players_on_match_id'
    t.index ['player_id'], name: 'index_match_players_on_player_id'
  end

  create_table 'matches', force: :cascade do |t|
    t.integer 'order'
    t.bigint 'winner_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'tournament_id'
    t.integer 'number', default: 0, null: false
    t.index ['tournament_id'], name: 'index_matches_on_tournament_id'
    t.index ['winner_id'], name: 'index_matches_on_winner_id'
  end

  create_table 'players', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'tournament_players', force: :cascade do |t|
    t.bigint 'player_id', null: false
    t.bigint 'tournament_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['player_id'], name: 'index_tournament_players_on_player_id'
    t.index ['tournament_id'], name: 'index_tournament_players_on_tournament_id'
  end

  create_table 'tournaments', force: :cascade do |t|
    t.string 'name', null: false
    t.date 'start_date', null: false
    t.date 'end_date', null: false
    t.bigint 'champion_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'tournament_type', default: 'liga', null: false
    t.index ['champion_id'], name: 'index_tournaments_on_champion_id'
  end

  add_foreign_key 'match_players', 'matches'
  add_foreign_key 'match_players', 'players'
  add_foreign_key 'matches', 'players', column: 'winner_id', on_delete: :nullify
  add_foreign_key 'matches', 'tournaments'
  add_foreign_key 'tournament_players', 'players'
  add_foreign_key 'tournament_players', 'tournaments'
  add_foreign_key 'tournaments', 'players', column: 'champion_id', on_delete: :nullify
end
