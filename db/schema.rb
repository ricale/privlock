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

ActiveRecord::Schema.define(version: 20140516151856) do

  create_table "categories", force: true do |t|
    t.string   "name",                        null: false
    t.string   "parent_id"
    t.integer  "depth",           default: 0, null: false
    t.integer  "order_in_parent", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "family"
  end

  create_table "ccls", force: true do |t|
    t.string   "name",        null: false
    t.string   "url",         null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "writing_id",    null: false
    t.string   "email"
    t.string   "name"
    t.string   "password_hash"
    t.integer  "user_id"
    t.text     "content",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["writing_id"], name: "index_comments_on_writing_id", using: :btree

  create_table "settings", force: true do |t|
    t.boolean  "active"
    t.string   "title",             null: false
    t.integer  "number_of_writing", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ccl_id"
    t.string   "author_name"
    t.string   "author_email"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "name",                                   null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "writings", force: true do |t|
    t.string   "title",       null: false
    t.text     "content",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id", null: false
    t.integer  "user_id",     null: false
  end

end
