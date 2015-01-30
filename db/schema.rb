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

ActiveRecord::Schema.define(version: 20150130095004) do

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
    t.integer  "participant_id"
    t.string   "name",                                            null: false
    t.boolean  "enabled",                         default: true
    t.boolean  "is_practice",                     default: false
    t.integer  "position"
    t.boolean  "monday",                          default: true
    t.boolean  "tuesday",                         default: true
    t.boolean  "wednesday",                       default: true
    t.boolean  "thursday",                        default: true
    t.boolean  "friday",                          default: true
    t.boolean  "saturday",                        default: true
    t.boolean  "sunday",                          default: true
    t.integer  "image_set_id"
    t.boolean  "loop_animations",                 default: false
    t.integer  "animation_frame_rate"
    t.boolean  "use_staircase_method",            default: false
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
    t.string   "background_colour"
    t.boolean  "show_exit_button"
    t.integer  "exit_button_x"
    t.integer  "exit_button_y"
    t.integer  "exit_button_w"
    t.integer  "exit_button_h"
    t.string   "exit_button_bg"
    t.string   "exit_button_fg"
    t.integer  "num_buttons"
    t.string   "button1_text"
    t.string   "button2_text"
    t.string   "button3_text"
    t.string   "button4_text"
    t.float    "button_presentation_delay"
    t.string   "button1_bg"
    t.string   "button2_bg"
    t.string   "button3_bg"
    t.string   "button4_bg"
    t.string   "button1_fg"
    t.string   "button2_fg"
    t.string   "button3_fg"
    t.string   "button4_fg"
    t.integer  "button1_x"
    t.integer  "button1_y"
    t.integer  "button1_w"
    t.integer  "button1_h"
    t.integer  "button2_x"
    t.integer  "button2_y"
    t.integer  "button2_w"
    t.integer  "button2_h"
    t.integer  "button3_x"
    t.integer  "button3_y"
    t.integer  "button3_w"
    t.integer  "button3_h"
    t.integer  "button4_x"
    t.integer  "button4_y"
    t.integer  "button4_w"
    t.integer  "button4_h"
    t.boolean  "require_next"
    t.float    "time_between_question_mean"
    t.float    "time_between_question_plusminus"
    t.boolean  "infinite_presentation_time"
    t.float    "finite_presentation_time"
    t.boolean  "infinite_response_window"
    t.float    "finite_response_window"
    t.boolean  "use_specified_seed"
    t.string   "specified_seed"
    t.boolean  "attempt_facial_recognition"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "configurations", ["image_set_id"], name: "index_configurations_on_image_set_id", using: :btree
  add_index "configurations", ["participant_id"], name: "index_configurations_on_participant_id", using: :btree

  create_table "image_frames", force: :cascade do |t|
    t.integer  "image_id"
    t.string   "frame_file_name"
    t.string   "frame_content_type"
    t.integer  "frame_file_size"
    t.datetime "frame_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "image_groups", force: :cascade do |t|
    t.integer  "image_set_id"
    t.string   "name",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "image_groups", ["image_set_id"], name: "index_image_groups_on_image_set_id", using: :btree

  create_table "image_sets", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.datetime "test_date"
    t.text     "content"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "logs", ["participant_id"], name: "index_logs_on_participant_id", using: :btree

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
    t.string   "role"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
