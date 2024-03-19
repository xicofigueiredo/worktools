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

ActiveRecord::Schema[7.0].define(version: 2024_03_19_012651) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "kdas_question_id", null: false
    t.string "answer_type"
    t.bigint "question_id", null: false
    t.bigint "questions_sprint_goal_id"
    t.index ["kdas_question_id"], name: "index_answers_on_kdas_question_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["questions_sprint_goal_id"], name: "index_answers_on_questions_sprint_goal_id"
  end

  create_table "exam_dates", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_exam_dates_on_subject_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.string "name"
    t.boolean "bga"
    t.index ["user_id"], name: "index_holidays_on_user_id"
  end

  create_table "hubs", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "kdas_questions", force: :cascade do |t|
    t.bigint "kda_id", null: false
    t.bigint "question_id", null: false
    t.index ["question_id"], name: "index_kdas_questions_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "kda"
    t.boolean "sprint"
  end

  create_table "questions_sprint_goals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subject_id", null: false
    t.bigint "question_id", null: false
    t.bigint "sprint_goal_id", null: false
    t.index ["question_id"], name: "index_questions_sprint_goals_on_question_id"
    t.index ["sprint_goal_id"], name: "index_questions_sprint_goals_on_sprint_goal_id"
    t.index ["subject_id"], name: "index_questions_sprint_goals_on_subject_id"
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

  create_table "timelines", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.bigint "user_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "total_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "balance"
    t.string "exam_season"
    t.integer "expected_progress"
    t.integer "progress"
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

  create_table "weekly_slots", force: :cascade do |t|
    t.bigint "weekly_goal_id", null: false
    t.integer "day_of_week"
    t.integer "time_slot"
    t.string "subject_name"
    t.string "topic_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["weekly_goal_id"], name: "index_weekly_slots_on_weekly_goal_id"
  end

  create_table "weeks", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "kdas_questions"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "questions_sprint_goals"
  add_foreign_key "exam_dates", "subjects"
  add_foreign_key "holidays", "users"
  add_foreign_key "kdas", "users"
  add_foreign_key "kdas", "weeks"
  add_foreign_key "kdas_questions", "questions"
  add_foreign_key "questions_sprint_goals", "questions"
  add_foreign_key "questions_sprint_goals", "sprint_goals"
  add_foreign_key "questions_sprint_goals", "subjects"
  add_foreign_key "sprint_goals", "sprints"
  add_foreign_key "sprint_goals", "users"
  add_foreign_key "timelines", "subjects"
  add_foreign_key "timelines", "users"
  add_foreign_key "topics", "subjects"
  add_foreign_key "user_topics", "topics"
  add_foreign_key "user_topics", "users"
  add_foreign_key "users_hubs", "hubs"
  add_foreign_key "users_hubs", "users"
  add_foreign_key "weekly_goals", "users"
  add_foreign_key "weekly_goals", "weeks"
  add_foreign_key "weekly_slots", "weekly_goals"
end
