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

ActiveRecord::Schema[7.0].define(version: 2024_09_15_192210) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "match_players", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "match_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points"
    t.index ["match_id"], name: "index_match_players_on_match_id"
    t.index ["player_id"], name: "index_match_players_on_player_id"
  end

  create_table "match_positions", force: :cascade do |t|
    t.integer "position", null: false
    t.integer "total_matches", null: false
    t.integer "total_points", null: false
    t.integer "matches_won", null: false
    t.boolean "eligible_for_tournament"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "ratio"
    t.bigint "match_id"
    t.bigint "player_id"
    t.index ["match_id"], name: "index_match_positions_on_match_id"
    t.index ["player_id"], name: "index_match_positions_on_player_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "order"
    t.bigint "winner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tournament_id"
    t.integer "number", default: 0, null: false
    t.bigint "created_by_id", default: 1, null: false
    t.index ["created_by_id"], name: "index_matches_on_created_by_id"
    t.index ["tournament_id"], name: "index_matches_on_tournament_id"
    t.index ["winner_id"], name: "index_matches_on_winner_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournament_players", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "tournament_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_tournament_players_on_player_id"
    t.index ["tournament_id"], name: "index_tournament_players_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.bigint "champion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tournament_type", default: "liga", null: false
    t.text "description", default: "Se computan puntos ganados sobre partidos jugados. Sumandose 2 puntos al ganador de la partida. Para que sea válida la participación de un jugador en búsqueda del título tiene que haber jugado al menos la mitad de catanes del jugador con más presencias. Solo son válidos los catanes de 4,5 o 6 jugadores. La última fecha del torneo puede ser como máximo antes del cambio de estación. Los catanes viajeros no computan. El premio está a definirse. En caso de igualdad de porcentaje, gana el torneo el que mas catanes ganados tenga.", null: false
    t.string "alias", default: "actual", null: false
    t.index ["champion_id"], name: "index_tournaments_on_champion_id"
  end

  add_foreign_key "match_players", "matches"
  add_foreign_key "match_players", "players"
  add_foreign_key "matches", "players", column: "created_by_id", on_delete: :nullify
  add_foreign_key "matches", "players", column: "winner_id", on_delete: :nullify
  add_foreign_key "matches", "tournaments"
  add_foreign_key "tournament_players", "players"
  add_foreign_key "tournament_players", "tournaments"
  add_foreign_key "tournaments", "players", column: "champion_id", on_delete: :nullify
end
