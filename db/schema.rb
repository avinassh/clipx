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

ActiveRecord::Schema.define(version: 20141004065414) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.text     "url"
    t.text     "title"
    t.text     "heading"
    t.text     "content"
    t.text     "image"
    t.text     "tags"
    t.string   "provider"
    t.string   "status",     default: "fetched"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "articles", ["url", "user_id"], name: "index_articles_on_url_and_user_id", unique: true, using: :btree

  create_table "bookmark_accounts", force: true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.integer  "last_fetched", default: 1412406208
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dropbox_accounts", force: true do |t|
    t.string  "email"
    t.string  "uid"
    t.string  "token"
    t.integer "user_id"
  end

  add_index "dropbox_accounts", ["uid"], name: "index_dropbox_accounts_on_uid", unique: true, using: :btree
  add_index "dropbox_accounts", ["user_id"], name: "index_dropbox_accounts_on_user_id", using: :btree

  create_table "evernote_accounts", force: true do |t|
    t.string  "token"
    t.integer "last_published"
    t.string  "username"
    t.integer "user_id"
    t.string  "notestore_url"
    t.string  "notebook_guid"
  end

  add_index "evernote_accounts", ["user_id"], name: "index_evernote_accounts_on_user_id", using: :btree
  add_index "evernote_accounts", ["username"], name: "index_evernote_accounts_on_username", unique: true, using: :btree

  create_table "github_accounts", force: true do |t|
    t.integer "uid"
    t.string  "username"
    t.string  "token"
    t.integer "last_fetched"
    t.integer "user_id"
  end

  add_index "github_accounts", ["uid"], name: "index_github_accounts_on_uid", unique: true, using: :btree
  add_index "github_accounts", ["user_id"], name: "index_github_accounts_on_user_id", using: :btree

  create_table "google_accounts", force: true do |t|
    t.string  "email"
    t.string  "refresh_token"
    t.string  "token"
    t.integer "last_published",             default: 1406603568
    t.integer "token_expiry"
    t.string  "spreadsheet_id", limit: 500
    t.integer "user_id"
  end

  create_table "pocket_accounts", force: true do |t|
    t.string  "token"
    t.integer "last_fetched"
    t.string  "username"
    t.integer "user_id"
  end

  add_index "pocket_accounts", ["user_id"], name: "index_pocket_accounts_on_user_id", using: :btree
  add_index "pocket_accounts", ["username"], name: "index_pocket_accounts_on_username", unique: true, using: :btree

  create_table "publish_statuses", force: true do |t|
    t.integer  "article_id"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publish_statuses", ["article_id"], name: "index_publish_statuses_on_article_id", using: :btree

  create_table "twitter_accounts", force: true do |t|
    t.integer "uid"
    t.string  "username"
    t.string  "token"
    t.string  "secret"
    t.string  "last_fetched_id"
    t.integer "last_fetched"
    t.integer "user_id"
  end

  add_index "twitter_accounts", ["uid"], name: "index_twitter_accounts_on_uid", unique: true, using: :btree
  add_index "twitter_accounts", ["user_id"], name: "index_twitter_accounts_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
