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

ActiveRecord::Schema.define(version: 20151116042729) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "configurations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "participant_id"
    t.string   "type",                                                                                                                            null: false
    t.string   "name",                                                                                                                            null: false
    t.string   "title"
    t.boolean  "enabled",                         default: true,                                                                                  null: false
    t.boolean  "is_practice",                     default: false,                                                                                 null: false
    t.integer  "position",                        default: 0,                                                                                     null: false
    t.string   "days_of_week",                    default: "---\n- monday\n- tuesday\n- wednesday\n- thursday\n- friday\n- saturday\n- sunday\n", null: false
    t.integer  "image_set_id",                                                                                                                    null: false
    t.boolean  "loop_animations",                 default: false,                                                                                 null: false
    t.integer  "animation_frame_rate"
    t.boolean  "use_staircase_method",            default: false,                                                                                 null: false
    t.integer  "number_of_staircases"
    t.string   "start_level"
    t.string   "number_of_reversals"
    t.string   "hits_to_finish"
    t.string   "minimum_level"
    t.string   "maximum_level"
    t.string   "delta_values"
    t.string   "num_wrong_to_get_easier"
    t.string   "num_correct_to_get_harder"
    t.string   "questions_per_folder"
    t.string   "background_colour",               default: "#000000",                                                                             null: false
    t.boolean  "show_exit_button",                default: true,                                                                                  null: false
    t.integer  "exit_button_x",                   default: 994
    t.integer  "exit_button_y",                   default: 30
    t.integer  "exit_button_w",                   default: 30
    t.integer  "exit_button_h",                   default: 30
    t.string   "exit_button_bg",                  default: "#6c6c6c"
    t.string   "exit_button_fg",                  default: "#ffffff"
    t.integer  "num_buttons",                     default: 1
    t.string   "button1_text"
    t.string   "button2_text"
    t.string   "button3_text"
    t.string   "button4_text"
    t.float    "button_presentation_delay",       default: 0.0,                                                                                   null: false
    t.string   "button1_bg",                      default: "#6c6c6c"
    t.string   "button2_bg",                      default: "#6c6c6c"
    t.string   "button3_bg",                      default: "#6c6c6c"
    t.string   "button4_bg",                      default: "#6c6c6c"
    t.string   "button1_fg",                      default: "#ffffff"
    t.string   "button2_fg",                      default: "#ffffff"
    t.string   "button3_fg",                      default: "#ffffff"
    t.string   "button4_fg",                      default: "#ffffff"
    t.integer  "button1_x",                       default: 237
    t.integer  "button1_y",                       default: 698
    t.integer  "button1_w",                       default: 100
    t.integer  "button1_h",                       default: 40
    t.integer  "button2_x",                       default: 387
    t.integer  "button2_y",                       default: 698
    t.integer  "button2_w",                       default: 100
    t.integer  "button2_h",                       default: 40
    t.integer  "button3_x",                       default: 537
    t.integer  "button3_y",                       default: 698
    t.integer  "button3_w",                       default: 100
    t.integer  "button3_h",                       default: 40
    t.integer  "button4_x",                       default: 687
    t.integer  "button4_y",                       default: 698
    t.integer  "button4_w",                       default: 100
    t.integer  "button4_h",                       default: 40
    t.boolean  "require_next",                    default: false,                                                                                 null: false
    t.float    "time_between_question_mean",      default: 0.0,                                                                                   null: false
    t.float    "time_between_question_plusminus", default: 0.0,                                                                                   null: false
    t.boolean  "infinite_presentation_time",      default: true,                                                                                  null: false
    t.float    "finite_presentation_time"
    t.boolean  "infinite_response_window",        default: true,                                                                                  null: false
    t.float    "finite_response_window"
    t.boolean  "use_specified_seed",              default: false,                                                                                 null: false
    t.string   "specified_seed"
    t.boolean  "attempt_facial_recognition",      default: false,                                                                                 null: false
    t.datetime "created_at",                                                                                                                      null: false
    t.datetime "updated_at",                                                                                                                      null: false
    t.string   "description"
  end

  add_index "configurations", ["image_set_id"], name: "index_configurations_on_image_set_id", using: :btree
  add_index "configurations", ["participant_id"], name: "index_configurations_on_participant_id", using: :btree
  add_index "configurations", ["user_id"], name: "index_configurations_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "image_frames", force: :cascade do |t|
    t.integer  "image_id"
    t.string   "frame_name"
    t.string   "frame_path"
    t.integer  "frame_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "image_frames", ["image_id"], name: "index_image_frames_on_image_id", using: :btree

  create_table "image_groups", force: :cascade do |t|
    t.integer  "image_set_id"
    t.string   "name",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "image_groups", ["image_set_id"], name: "index_image_groups_on_image_set_id", using: :btree

  create_table "image_sets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "directory",             null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "background_image_path"
    t.integer  "background_image_size"
    t.string   "title_image_path"
    t.integer  "title_image_size"
  end

  add_index "image_sets", ["user_id"], name: "index_image_sets_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "image_group_id"
    t.string   "name",                           null: false
    t.boolean  "animated",       default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "images", ["image_group_id"], name: "index_images_on_image_group_id", using: :btree

  create_table "logs", force: :cascade do |t|
    t.integer  "participant_id"
    t.datetime "test_date",      null: false
    t.text     "content",        null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
  end

  add_index "logs", ["participant_id"], name: "index_logs_on_participant_id", using: :btree
  add_index "logs", ["user_id"], name: "index_logs_on_user_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "username",                  null: false
    t.boolean  "enabled",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "participants", ["user_id"], name: "index_participants_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "string"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "affiliation"
    t.string   "hook_url"
    t.integer  "default_participant_id"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["default_participant_id"], name: "index_users_on_default_participant_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "logs", "users"
end
