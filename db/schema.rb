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

ActiveRecord::Schema.define(version: 20151013052857) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_us", force: :cascade do |t|
    t.string   "email"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string   "email"
    t.boolean  "principal",  default: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "emails", ["email"], name: "index_emails_on_email", using: :btree
  add_index "emails", ["user_id"], name: "index_emails_on_user_id", using: :btree

  create_table "faqs", force: :cascade do |t|
    t.string  "question"
    t.string  "answer"
    t.integer "order"
  end

  create_table "features", force: :cascade do |t|
    t.string "name", limit: 20
  end

  create_table "plan_features", force: :cascade do |t|
    t.integer "plan_id"
    t.integer "feature_id"
    t.string  "value",      limit: 20
  end

  add_index "plan_features", ["feature_id"], name: "index_plan_features_on_feature_id", using: :btree
  add_index "plan_features", ["plan_id"], name: "index_plan_features_on_plan_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string  "name"
    t.decimal "amount_per_month"
  end

  create_table "security", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "ip"
    t.integer  "user_id"
    t.integer  "user_action_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "security", ["user_action_id"], name: "index_security_on_user_action_id", using: :btree
  add_index "security", ["user_id"], name: "index_security_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 15
    t.string   "first_name",             limit: 15
    t.string   "last_name",              limit: 15
    t.string   "address"
    t.string   "country_code",           limit: 3
    t.string   "phone",                  limit: 15
    t.boolean  "status",                            default: true
    t.boolean  "receive_notif_last_new",            default: true
    t.string   "passwd"
    t.string   "passwd_salt"
    t.string   "auth_token"
    t.integer  "plan_id"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "users", ["plan_id"], name: "index_users_on_plan_id", using: :btree
  add_index "users", ["status"], name: "index_users_on_status", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
