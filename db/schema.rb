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

ActiveRecord::Schema.define(version: 20170716151422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "longtrainbookingtockens", force: :cascade do |t|
    t.string "btocken"
    t.string "userauth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "longtrains", force: :cascade do |t|
    t.string "rtocken"
    t.string "btocken"
    t.string "category"
    t.string "boarding"
    t.string "destination"
    t.string "location"
    t.date "datetime"
    t.integer "seat"
    t.string "custID"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cost"
    t.string "detail"
    t.index ["user_id"], name: "index_longtrains_on_user_id"
  end

  create_table "longtraintockens", force: :cascade do |t|
    t.string "rtocken"
    t.string "userauth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seatcounter"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.integer "aticket"
    t.integer "cticket"
    t.string "tfrom"
    t.string "tto"
    t.string "tclass"
    t.string "treturn"
    t.string "tvhour"
    t.string "tvdate"
    t.string "proof"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "userid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.boolean "admin"
    t.boolean "checker"
  end

  add_foreign_key "longtrains", "users"
  add_foreign_key "tickets", "users"
end
