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

ActiveRecord::Schema.define(version: 20150706015749) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "project_perms", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "project_perms", ["name"], name: "index_project_perms_on_name", using: :btree

  create_table "project_rol_user_perms", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "project_rols_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "project_rol_user_perms", ["project_id"], name: "index_project_rol_user_perms_on_project_id", using: :btree
  add_index "project_rol_user_perms", ["project_rols_id"], name: "index_project_rol_user_perms_on_project_rols_id", using: :btree
  add_index "project_rol_user_perms", ["user_id"], name: "index_project_rol_user_perms_on_user_id", using: :btree

  create_table "project_rols", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "project_rols", ["name"], name: "index_project_rols_on_name", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "projects", ["name"], name: "index_projects_on_name", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "space_perms", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "space_perms", ["name"], name: "index_space_perms_on_name", using: :btree

  create_table "space_rol_user_perms", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "space_id"
    t.integer  "space_rols_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "space_rol_user_perms", ["space_id"], name: "index_space_rol_user_perms_on_space_id", using: :btree
  add_index "space_rol_user_perms", ["space_rols_id"], name: "index_space_rol_user_perms_on_space_rols_id", using: :btree
  add_index "space_rol_user_perms", ["user_id"], name: "index_space_rol_user_perms_on_user_id", using: :btree

  create_table "space_rols", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "space_rols", ["name"], name: "index_space_rols_on_name", using: :btree

  create_table "spaces", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "spaces", ["name"], name: "index_spaces_on_name", using: :btree
  add_index "spaces", ["user_id"], name: "index_spaces_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "passwd"
    t.string   "passwd_salt"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
