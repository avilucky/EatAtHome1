# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151207043635) do

  create_table "follows", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cook_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "follows", ["cook_id", "user_id"], name: "index_follows_on_cook_id_and_user_id", unique: true

  create_table "food_images", force: :cascade do |t|
    t.integer  "food_item_id"
    t.string   "avatar"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "food_item_portions", force: :cascade do |t|
    t.string  "portion"
    t.decimal "price",        precision: 10, scale: 2
    t.integer "food_item_id"
  end

  create_table "food_items", force: :cascade do |t|
    t.string  "name"
    t.string  "category"
    t.string  "description"
    t.integer "user_id"
    t.boolean "availability", default: true
  end

  create_table "food_reviews", force: :cascade do |t|
    t.integer  "rating"
    t.text     "comment"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
    t.integer  "food_item_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "seller_id"
    t.integer  "food_item_portion_id"
    t.decimal  "price_per_portion"
    t.integer  "quantity"
    t.integer  "status",               default: 0, null: false
    t.datetime "accepted_time"
  end

  create_table "user_images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
    t.string  "password_digest"
    t.string  "address_one"
    t.string  "address_two"
    t.string  "apt_num"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "verification_code"
    t.string  "password_reset_token"
    t.boolean "availability",         default: true
    t.float   "latitude"
    t.float   "longitude"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token"

end
