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

ActiveRecord::Schema.define(version: 20160123185543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "api_key"
  end

  add_index "api_keys", ["api_key"], name: "index_api_keys_on_api_key", unique: true, using: :btree

  create_table "chart_histories", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "space_id"
    t.integer  "user_id"
    t.string   "stage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chart_histories", ["project_id"], name: "index_chart_histories_on_project_id", using: :btree
  add_index "chart_histories", ["space_id"], name: "index_chart_histories_on_space_id", using: :btree
  add_index "chart_histories", ["user_id"], name: "index_chart_histories_on_user_id", using: :btree

  create_table "chart_history_params", force: :cascade do |t|
    t.integer  "chart_history_id"
    t.integer  "project_id"
    t.string   "param"
    t.string   "value"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "chart_history_params", ["chart_history_id"], name: "index_chart_history_params_on_chart_history_id", using: :btree
  add_index "chart_history_params", ["project_id"], name: "index_chart_history_params_on_project_id", using: :btree

  create_table "contact_us", force: :cascade do |t|
    t.string   "email"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "descrips", force: :cascade do |t|
    t.string "description"
    t.string "icon"
    t.string "lang",        default: "en"
    t.string "title"
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
    t.string "question"
    t.string "answer"
    t.string "lang",     default: "en"
  end

  create_table "features", force: :cascade do |t|
    t.string "name"
  end

  create_table "logs", force: :cascade do |t|
    t.text     "description"
    t.string   "action",         limit: 20
    t.integer  "user_id"
    t.integer  "user_action_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "logs", ["user_action_id"], name: "index_logs_on_user_action_id", using: :btree
  add_index "logs", ["user_id"], name: "index_logs_on_user_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string "category"
    t.string "permission"
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

  create_table "project_evaluators", force: :cascade do |t|
    t.text     "script"
    t.integer  "user_id"
    t.integer  "space_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "project_evaluators", ["project_id"], name: "index_project_evaluators_on_project_id", using: :btree
  add_index "project_evaluators", ["space_id"], name: "index_project_evaluators_on_space_id", using: :btree
  add_index "project_evaluators", ["user_id"], name: "index_project_evaluators_on_user_id", using: :btree

  create_table "project_parameters", force: :cascade do |t|
    t.string   "name"
    t.string   "type_param"
    t.integer  "user_id"
    t.integer  "space_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "project_parameters", ["project_id"], name: "index_project_parameters_on_project_id", using: :btree
  add_index "project_parameters", ["space_id"], name: "index_project_parameters_on_space_id", using: :btree
  add_index "project_parameters", ["user_id"], name: "index_project_parameters_on_user_id", using: :btree

  create_table "project_request_from_clients", force: :cascade do |t|
    t.string  "ips"
    t.integer "project_request_id"
  end

  add_index "project_request_from_clients", ["project_request_id"], name: "index_project_request_from_clients_on_project_request_id", using: :btree

  create_table "project_request_to_servers", force: :cascade do |t|
    t.string  "url"
    t.string  "method"
    t.string  "content_type"
    t.string  "raw"
    t.integer "project_request_id"
  end

  add_index "project_request_to_servers", ["project_request_id"], name: "index_project_request_to_servers_on_project_request_id", using: :btree

  create_table "project_requests", force: :cascade do |t|
    t.integer  "request_per_min"
    t.string   "way"
    t.string   "token"
    t.integer  "user_id"
    t.integer  "space_id"
    t.integer  "project_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "project_requests", ["project_id"], name: "index_project_requests_on_project_id", using: :btree
  add_index "project_requests", ["space_id"], name: "index_project_requests_on_space_id", using: :btree
  add_index "project_requests", ["user_id"], name: "index_project_requests_on_user_id", using: :btree

  create_table "project_webhooks", force: :cascade do |t|
    t.string   "url"
    t.string   "token"
    t.integer  "user_id"
    t.integer  "space_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "project_webhooks", ["project_id"], name: "index_project_webhooks_on_project_id", using: :btree
  add_index "project_webhooks", ["space_id"], name: "index_project_webhooks_on_space_id", using: :btree
  add_index "project_webhooks", ["user_id"], name: "index_project_webhooks_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_public",     default: true
    t.boolean  "can_subscribe", default: true
    t.integer  "user_id"
    t.integer  "space_id"
    t.integer  "user_owner_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "projects", ["space_id"], name: "index_projects_on_space_id", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree
  add_index "projects", ["user_owner_id"], name: "index_projects_on_user_owner_id", using: :btree

  create_table "securities", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "ip"
    t.integer  "user_id"
    t.integer  "user_action_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "securities", ["user_action_id"], name: "index_securities_on_user_action_id", using: :btree
  add_index "securities", ["user_id"], name: "index_securities_on_user_id", using: :btree

  create_table "spaces", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_public",     default: true
    t.boolean  "can_subscribe", default: true
    t.integer  "user_id"
    t.integer  "user_owner_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "spaces", ["user_id"], name: "index_spaces_on_user_id", using: :btree
  add_index "spaces", ["user_owner_id"], name: "index_spaces_on_user_owner_id", using: :btree

  create_table "stage_projects", force: :cascade do |t|
    t.string   "stage",            limit: 15
    t.boolean  "notif_by_email",              default: true
    t.boolean  "notif_by_sms",                default: false
    t.boolean  "notif_by_webhook",            default: false
    t.integer  "user_id"
    t.integer  "space_id"
    t.integer  "project_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "stage_projects", ["project_id"], name: "index_stage_projects_on_project_id", using: :btree
  add_index "stage_projects", ["space_id"], name: "index_stage_projects_on_space_id", using: :btree
  add_index "stage_projects", ["user_id"], name: "index_stage_projects_on_user_id", using: :btree

  create_table "stage_spaces", force: :cascade do |t|
    t.string   "stage",            limit: 15
    t.boolean  "notif_by_email",              default: true
    t.boolean  "notif_by_sms",                default: false
    t.boolean  "notif_by_webhook",            default: false
    t.integer  "user_id"
    t.integer  "space_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "stage_spaces", ["space_id"], name: "index_stage_spaces_on_space_id", using: :btree
  add_index "stage_spaces", ["user_id"], name: "index_stage_spaces_on_user_id", using: :btree

  create_table "team_projects", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "permission_id"
    t.integer  "space_id"
    t.integer  "project_id"
    t.integer  "user_team_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "team_projects", ["permission_id"], name: "index_team_projects_on_permission_id", using: :btree
  add_index "team_projects", ["project_id"], name: "index_team_projects_on_project_id", using: :btree
  add_index "team_projects", ["space_id"], name: "index_team_projects_on_space_id", using: :btree
  add_index "team_projects", ["user_id"], name: "index_team_projects_on_user_id", using: :btree
  add_index "team_projects", ["user_team_id"], name: "index_team_projects_on_user_team_id", using: :btree

  create_table "team_spaces", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "permission_id"
    t.integer  "space_id"
    t.integer  "user_team_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "team_spaces", ["permission_id"], name: "index_team_spaces_on_permission_id", using: :btree
  add_index "team_spaces", ["space_id"], name: "index_team_spaces_on_space_id", using: :btree
  add_index "team_spaces", ["user_id"], name: "index_team_spaces_on_user_id", using: :btree
  add_index "team_spaces", ["user_team_id"], name: "index_team_spaces_on_user_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "user_team_id"
    t.integer  "permission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "teams", ["permission_id"], name: "index_teams_on_permission_id", using: :btree
  add_index "teams", ["user_id"], name: "index_teams_on_user_id", using: :btree
  add_index "teams", ["user_team_id"], name: "index_teams_on_user_team_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 45
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
    t.integer  "api_key_id"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "users", ["api_key_id"], name: "index_users_on_api_key_id", using: :btree
  add_index "users", ["plan_id"], name: "index_users_on_plan_id", using: :btree
  add_index "users", ["status"], name: "index_users_on_status", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
