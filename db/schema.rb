# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_04_01_031418) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "communities", force: :cascade do |t|
    t.bigint "sprint_goal_id", null: false
    t.string "involved"
    t.text "smartgoals"
    t.text "difficulties"
    t.text "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sprint_goal_id"], name: "index_communities_on_sprint_goal_id"
  end

  create_table "exam_dates", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_exam_dates_on_subject_id"
  end

  create_table "excel_imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friday_slots", force: :cascade do |t|
    t.bigint "weekly_meeting_id", null: false
    t.string "time_slot"
    t.bigint "lc_id"
    t.bigint "learner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lc_id"], name: "index_friday_slots_on_lc_id"
    t.index ["learner_id"], name: "index_friday_slots_on_learner_id"
    t.index ["weekly_meeting_id"], name: "index_friday_slots_on_weekly_meeting_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.bigint "user_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.string "name"
    t.boolean "bga"
    t.index ["user_id"], name: "index_holidays_on_user_id"
  end

  create_table "hubps", force: :cascade do |t|
    t.integer "rating"
    t.text "why"
    t.text "improve"
    t.bigint "kda_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kda_id"], name: "index_hubps_on_kda_id"
  end

  create_table "hubs", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inis", force: :cascade do |t|
    t.integer "rating"
    t.text "why"
    t.text "improve"
    t.bigint "kda_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kda_id"], name: "index_inis_on_kda_id"
  end

  create_table "kdas", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "week_id", null: false
    t.index ["user_id"], name: "index_kdas_on_user_id"
    t.index ["week_id"], name: "index_kdas_on_week_id"
  end

  create_table "knowledges", force: :cascade do |t|
    t.bigint "sprint_goal_id", null: false
    t.text "difficulties"
    t.text "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "timeline_id"
    t.index ["sprint_goal_id"], name: "index_knowledges_on_sprint_goal_id"
    t.index ["timeline_id"], name: "index_knowledges_on_timeline_id"
  end

  create_table "monday_slots", force: :cascade do |t|
    t.bigint "weekly_meeting_id", null: false
    t.string "time_slot"
    t.bigint "lc_id"
    t.bigint "learner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lc_id"], name: "index_monday_slots_on_lc_id"
    t.index ["learner_id"], name: "index_monday_slots_on_learner_id"
    t.index ["weekly_meeting_id"], name: "index_monday_slots_on_weekly_meeting_id"
  end

  create_table "mots", force: :cascade do |t|
    t.integer "rating"
    t.text "why"
    t.text "improve"
    t.bigint "kda_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kda_id"], name: "index_mots_on_kda_id"
  end

  create_table "p2ps", force: :cascade do |t|
    t.integer "rating"
    t.text "why"
    t.text "improve"
    t.bigint "kda_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kda_id"], name: "index_p2ps_on_kda_id"
  end

  create_table "sdls", force: :cascade do |t|
    t.integer "rating"
    t.text "why"
    t.text "improve"
    t.bigint "kda_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kda_id"], name: "index_sdls_on_kda_id"
  end

  create_table "skills", force: :cascade do |t|
    t.bigint "sprint_goal_id", null: false
    t.string "extracurricular"
    t.text "smartgoals"
    t.text "difficulties"
    t.text "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sprint_goal_id"], name: "index_skills_on_sprint_goal_id"
  end

  create_table "sprint_goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sprint_id", null: false
    t.index ["sprint_id"], name: "index_sprint_goals_on_sprint_id"
    t.index ["user_id"], name: "index_sprint_goals_on_user_id"
  end

  create_table "sprints", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.integer "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "thursday_slots", force: :cascade do |t|
    t.bigint "weekly_meeting_id", null: false
    t.string "time_slot"
    t.bigint "lc_id"
    t.bigint "learner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lc_id"], name: "index_thursday_slots_on_lc_id"
    t.index ["learner_id"], name: "index_thursday_slots_on_learner_id"
    t.index ["weekly_meeting_id"], name: "index_thursday_slots_on_weekly_meeting_id"
  end

  create_table "timelines", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.bigint "user_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "total_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "balance"
    t.integer "expected_progress"
    t.integer "progress"
    t.bigint "exam_date_id"
    t.index ["exam_date_id"], name: "index_timelines_on_exam_date_id"
    t.index ["subject_id"], name: "index_timelines_on_subject_id"
    t.index ["user_id"], name: "index_timelines_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.integer "time"
    t.string "name"
    t.boolean "has_grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "milestone"
    t.string "unit"
    t.boolean "Mock50"
    t.boolean "Mock100"
    t.index ["subject_id"], name: "index_topics_on_subject_id"
  end

  create_table "tuesday_slots", force: :cascade do |t|
    t.bigint "weekly_meeting_id", null: false
    t.string "time_slot"
    t.bigint "lc_id"
    t.bigint "learner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lc_id"], name: "index_tuesday_slots_on_lc_id"
    t.index ["learner_id"], name: "index_tuesday_slots_on_learner_id"
    t.index ["weekly_meeting_id"], name: "index_tuesday_slots_on_weekly_meeting_id"
  end

  create_table "user_topics", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "topic_id", null: false
    t.float "grade"
    t.boolean "done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "deadline"
    t.float "percentage"
    t.index ["topic_id"], name: "index_user_topics_on_topic_id"
    t.index ["user_id"], name: "index_user_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "role"
    t.integer "topics_balance", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_hubs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "hub_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hub_id"], name: "index_users_hubs_on_hub_id"
    t.index ["user_id"], name: "index_users_hubs_on_user_id"
  end

  create_table "wednesday_slots", force: :cascade do |t|
    t.bigint "weekly_meeting_id", null: false
    t.string "time_slot"
    t.bigint "lc_id"
    t.bigint "learner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lc_id"], name: "index_wednesday_slots_on_lc_id"
    t.index ["learner_id"], name: "index_wednesday_slots_on_learner_id"
    t.index ["weekly_meeting_id"], name: "index_wednesday_slots_on_weekly_meeting_id"
  end

  create_table "weekly_goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.bigint "week_id"
    t.index ["user_id"], name: "index_weekly_goals_on_user_id"
    t.index ["week_id"], name: "index_weekly_goals_on_week_id"
  end

  create_table "weekly_meetings", force: :cascade do |t|
    t.bigint "week_id", null: false
    t.bigint "hub_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hub_id"], name: "index_weekly_meetings_on_hub_id"
    t.index ["week_id"], name: "index_weekly_meetings_on_week_id"
  end

  create_table "weekly_slots", force: :cascade do |t|
    t.bigint "weekly_goal_id", null: false
    t.integer "day_of_week"
    t.integer "time_slot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject_name"
    t.string "topic_name"
    t.index ["weekly_goal_id"], name: "index_weekly_slots_on_weekly_goal_id"
  end

  create_table "weeks", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sprint_id"
    t.index ["sprint_id"], name: "index_weeks_on_sprint_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "communities", "sprint_goals"
  add_foreign_key "exam_dates", "subjects"
  add_foreign_key "friday_slots", "users", column: "lc_id"
  add_foreign_key "friday_slots", "users", column: "learner_id"
  add_foreign_key "friday_slots", "weekly_meetings"
  add_foreign_key "holidays", "users"
  add_foreign_key "hubps", "kdas"
  add_foreign_key "inis", "kdas"
  add_foreign_key "kdas", "users"
  add_foreign_key "kdas", "weeks"
  add_foreign_key "knowledges", "sprint_goals"
  add_foreign_key "knowledges", "timelines"
  add_foreign_key "monday_slots", "users", column: "lc_id"
  add_foreign_key "monday_slots", "users", column: "learner_id"
  add_foreign_key "monday_slots", "weekly_meetings"
  add_foreign_key "mots", "kdas"
  add_foreign_key "p2ps", "kdas"
  add_foreign_key "sdls", "kdas"
  add_foreign_key "skills", "sprint_goals"
  add_foreign_key "sprint_goals", "sprints"
  add_foreign_key "sprint_goals", "users"
  add_foreign_key "thursday_slots", "users", column: "lc_id"
  add_foreign_key "thursday_slots", "users", column: "learner_id"
  add_foreign_key "thursday_slots", "weekly_meetings"
  add_foreign_key "timelines", "exam_dates"
  add_foreign_key "timelines", "subjects"
  add_foreign_key "timelines", "users"
  add_foreign_key "topics", "subjects"
  add_foreign_key "tuesday_slots", "users", column: "lc_id"
  add_foreign_key "tuesday_slots", "users", column: "learner_id"
  add_foreign_key "tuesday_slots", "weekly_meetings"
  add_foreign_key "user_topics", "topics"
  add_foreign_key "user_topics", "users"
  add_foreign_key "users_hubs", "hubs"
  add_foreign_key "users_hubs", "users"
  add_foreign_key "wednesday_slots", "users", column: "lc_id"
  add_foreign_key "wednesday_slots", "users", column: "learner_id"
  add_foreign_key "wednesday_slots", "weekly_meetings"
  add_foreign_key "weekly_goals", "users"
  add_foreign_key "weekly_goals", "weeks"
  add_foreign_key "weekly_meetings", "hubs"
  add_foreign_key "weekly_meetings", "weeks"
  add_foreign_key "weekly_slots", "weekly_goals"
  add_foreign_key "weeks", "sprints"
end
