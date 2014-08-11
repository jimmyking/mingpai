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

ActiveRecord::Schema.define(version: 8) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "role"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "sort"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus_roles", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "menu_id"
  end

  create_table "orders", force: true do |t|
    t.string   "order_no"
    t.integer  "no"
    t.integer  "type_id"
    t.integer  "order_status_id"
    t.integer  "order_process_id"
    t.integer  "department_id"
    t.string   "acter"
    t.string   "level"
    t.string   "demand"
    t.string   "acter_account"
    t.string   "acter_pw"
    t.string   "wangwang"
    t.string   "mobile"
    t.string   "qq"
    t.string   "amount"
    t.string   "paytype"
    t.string   "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "steps", force: true do |t|
    t.string   "name"
    t.integer  "sort"
    t.integer  "value"
    t.integer  "type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "types", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
