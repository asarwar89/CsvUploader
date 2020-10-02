# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_30_133120) do

  create_table "affiliations", force: :cascade do |t|
    t.string "title"
    t.integer "person_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_affiliations_on_person_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.integer "person_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_locations_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "species"
    t.string "gender"
    t.string "weapon"
    t.string "vehicle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "affiliations", "people"
  add_foreign_key "locations", "people"
end
