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

ActiveRecord::Schema[7.0].define(version: 2025_07_03_143025) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "attendances", force: :cascade do |t|
    t.bigint "user_id"
    t.date "attendance_date"
    t.time "start_time"
    t.time "end_time"
    t.boolean "present"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "absence"
    t.index ["user_id", "attendance_date"], name: "index_attendances_on_user_id_and_attendance_date", unique: true
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "communities", force: :cascade do |t|
    t.bigint "sprint_goal_id", null: false
    t.string "involved"
    t.text "smartgoals"
    t.text "difficulties"
    t.text "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "categories", default: [], array: true
    t.index ["sprint_goal_id"], name: "index_communities_on_sprint_goal_id"
  end

  create_table "exam_dates", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_exam_dates_on_subject_id"
  end

  create_table "exam_enroll_documents", force: :cascade do |t|
    t.bigint "exam_enroll_id", null: false
    t.string "file_name"
    t.string "file_type"
    t.string "file_path"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_enroll_id"], name: "index_exam_enroll_documents_on_exam_enroll_id"
  end

  create_table "exam_enrolls", force: :cascade do |t|
    t.string "hub"
    t.string "learning_coach"
    t.string "learning_coach_email"
    t.string "learner_name"
    t.string "learner_id_type"
    t.string "learner_id_number"
    t.date "date_of_birth"
    t.string "gender"
    t.boolean "native_language_english"
    t.string "subject_name"
    t.string "code"
    t.string "qualification"
    t.string "progress_cut_off"
    t.string "mock_results"
    t.string "bga_exam_centre"
    t.string "exam_board"
    t.boolean "has_special_accommodations"
    t.string "special_accommodations_personalized"
    t.string "additional_comments"
    t.string "extension_justification"
    t.boolean "extension_cm_approval"
    t.string "extension_cm_comment"
    t.boolean "extension_edu_approval"
    t.string "extension_edu_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "moodle_timeline_id"
    t.boolean "extension_dc_approval"
    t.string "extension_dc_comment"
    t.boolean "repeating", default: false
    t.boolean "graduating", default: false
    t.string "pre_registration_exception_justification"
    t.boolean "pre_registration_exception_cm_approval"
    t.string "pre_registration_exception_cm_comment"
    t.boolean "pre_registration_exception_dc_approval"
    t.string "pre_registration_exception_dc_comment"
    t.boolean "pre_registration_exception_edu_approval"
    t.string "pre_registration_exception_edu_comment"
    t.string "failed_mock_exception_justification"
    t.boolean "failed_mock_exception_cm_approval"
    t.string "failed_mock_exception_cm_comment"
    t.boolean "failed_mock_exception_dc_approval"
    t.string "failed_mock_exception_dc_comment"
    t.boolean "failed_mock_exception_edu_approval"
    t.string "failed_mock_exception_edu_comment"
    t.string "status"
    t.index ["moodle_timeline_id"], name: "index_exam_enrolls_on_moodle_timeline_id"
  end

  create_table "excel_imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "form_interrogation_joins", force: :cascade do |t|
    t.bigint "form_id", null: false
    t.bigint "interrogation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id", "interrogation_id"], name: "index_form_interrogation_unique", unique: true
    t.index ["form_id"], name: "index_form_interrogation_joins_on_form_id"
    t.index ["interrogation_id"], name: "index_form_interrogation_joins_on_interrogation_id"
  end

  create_table "forms", force: :cascade do |t|
    t.string "title"
    t.datetime "scheduled_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
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
    t.string "name"
    t.boolean "bga"
    t.string "country"
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

  create_table "interrogations", force: :cascade do |t|
    t.string "content"
    t.boolean "active", default: true
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
    t.text "lc_comment"
    t.text "reflection"
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
    t.string "subject_name"
    t.string "mock50"
    t.string "mock100"
    t.string "exam_season"
    t.index ["sprint_goal_id"], name: "index_knowledges_on_sprint_goal_id"
    t.index ["timeline_id"], name: "index_knowledges_on_timeline_id"
  end

  create_table "learner_flags", force: :cascade do |t|
    t.boolean "asks_for_help", default: false
    t.boolean "takes_notes", default: false
    t.boolean "goes_to_live_lessons", default: false
    t.boolean "does_p2p", default: false
    t.text "action_plan", default: "", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "life_experiences", default: false
    t.index ["user_id"], name: "index_learner_flags_on_user_id"
  end

  create_table "lws_timelines", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "year"
    t.integer "balance"
    t.float "blocks_per_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "level"
    t.index ["user_id"], name: "index_lws_timelines_on_user_id"
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

  create_table "moodle_timelines", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "total_time"
    t.integer "balance"
    t.integer "expected_progress"
    t.integer "progress"
    t.bigint "exam_date_id"
    t.integer "category", null: false
    t.datetime "mock50"
    t.datetime "mock100"
    t.string "personalized_name"
    t.string "color"
    t.boolean "hidden"
    t.integer "difference"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subject_id"
    t.integer "moodle_id"
    t.boolean "as1"
    t.boolean "as2"
    t.boolean "blocks", default: [false, false, false, false], array: true
    t.index ["exam_date_id"], name: "index_moodle_timelines_on_exam_date_id"
    t.index ["subject_id"], name: "index_moodle_timelines_on_subject_id"
    t.index ["user_id"], name: "index_moodle_timelines_on_user_id"
  end

  create_table "moodle_topics", force: :cascade do |t|
    t.bigint "timeline_id"
    t.float "time", null: false
    t.string "name", null: false
    t.string "unit", null: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "grade"
    t.boolean "done", default: false, null: false
    t.datetime "completion_date"
    t.integer "moodle_id"
    t.date "deadline"
    t.float "percentage"
    t.boolean "mock50", default: false
    t.boolean "mock100", default: false
    t.integer "completion_data"
    t.string "submission_date"
    t.string "evaluation_date"
    t.integer "number_attempts", default: 0
    t.bigint "moodle_timeline_id"
    t.boolean "as1"
    t.boolean "as2"
    t.index ["moodle_timeline_id"], name: "index_moodle_topics_on_moodle_timeline_id"
    t.index ["timeline_id"], name: "index_moodle_topics_on_timeline_id"
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

  create_table "newsletters", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "published_at", null: false
    t.string "filter_country"
    t.string "filter_role"
    t.string "filter_level"
    t.string "filter_region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filter_country"], name: "index_newsletters_on_filter_country"
    t.index ["filter_level"], name: "index_newsletters_on_filter_level"
    t.index ["filter_region"], name: "index_newsletters_on_filter_region"
    t.index ["filter_role"], name: "index_newsletters_on_filter_role"
    t.index ["published_at"], name: "index_newsletters_on_published_at"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "category"
    t.string "topic"
    t.date "date"
    t.text "follow_up_action"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "message"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.index ["user_id"], name: "index_notifications_on_user_id"
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

  create_table "report_activities", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.string "activity"
    t.string "goal"
    t.text "reflection"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "skill_id"
    t.bigint "community_id"
    t.index ["community_id"], name: "index_report_activities_on_community_id"
    t.index ["report_id"], name: "index_report_activities_on_report_id"
    t.index ["skill_id"], name: "index_report_activities_on_skill_id"
  end

  create_table "report_knowledges", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.string "subject_name"
    t.integer "progress"
    t.integer "difference"
    t.string "grade"
    t.string "exam_season"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "personalized", default: false, null: false
    t.bigint "knowledge_id"
    t.index ["knowledge_id"], name: "index_report_knowledges_on_knowledge_id"
    t.index ["report_id"], name: "index_report_knowledges_on_report_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sprint_id", null: false
    t.text "general"
    t.text "lc_comment"
    t.text "reflection"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "sdl"
    t.text "ini"
    t.text "mot"
    t.text "p2p"
    t.text "hubp"
    t.integer "sdl_long_term_plans"
    t.integer "sdl_week_organization"
    t.integer "sdl_achieve_goals"
    t.integer "sdl_study_techniques"
    t.integer "sdl_initiative_office_hours"
    t.integer "ini_new_activities"
    t.integer "ini_goal_setting"
    t.integer "mot_integrity"
    t.integer "mot_improvement"
    t.integer "p2p_support_from_peers"
    t.integer "p2p_support_to_peers"
    t.integer "hub_cleanliness"
    t.integer "hub_respectful_behavior"
    t.integer "hub_welcome_others"
    t.integer "hub_participation"
    t.boolean "hide", default: true
    t.date "last_update_check"
    t.boolean "parent"
    t.integer "lc_ids", default: [], array: true
    t.index ["sprint_id"], name: "index_reports_on_sprint_id"
    t.index ["user_id", "sprint_id"], name: "index_reports_on_user_id_and_sprint_id", unique: true
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "form_interrogation_join_id", null: false
    t.bigint "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "completed_at"
    t.index ["form_interrogation_join_id"], name: "index_responses_on_form_interrogation_join_id"
    t.index ["user_id", "form_interrogation_join_id"], name: "index_user_interrogation_unique", unique: true
    t.index ["user_id"], name: "index_responses_on_user_id"
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
    t.string "category"
    t.string "categories", default: [], array: true
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
    t.integer "moodle_id"
    t.integer "topics_count", default: 0, null: false
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

  create_table "timeline_progresses", force: :cascade do |t|
    t.bigint "timeline_id", null: false
    t.bigint "week_id", null: false
    t.integer "progress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "expected", default: 0, null: false
    t.integer "difference", default: 0, null: false
    t.index ["timeline_id"], name: "index_timeline_progresses_on_timeline_id"
    t.index ["week_id"], name: "index_timeline_progresses_on_week_id"
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
    t.boolean "anulado"
    t.bigint "lws_timeline_id"
    t.datetime "mock50"
    t.datetime "mock100"
    t.string "personalized_name"
    t.string "color", default: "#F4F4F4"
    t.boolean "hidden", default: false
    t.integer "difference"
    t.index ["exam_date_id"], name: "index_timelines_on_exam_date_id"
    t.index ["lws_timeline_id"], name: "index_timelines_on_lws_timeline_id"
    t.index ["subject_id"], name: "index_timelines_on_subject_id"
    t.index ["user_id"], name: "index_timelines_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.decimal "time", precision: 5, scale: 2
    t.string "name"
    t.boolean "has_grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "milestone"
    t.string "unit"
    t.boolean "Mock50"
    t.boolean "Mock100"
    t.integer "order"
    t.bigint "moodle_id"
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
    t.bigint "timeline_id"
    t.index ["timeline_id"], name: "index_user_topics_on_timeline_id"
    t.index ["topic_id"], name: "index_user_topics_on_topic_id"
    t.index ["user_id", "topic_id"], name: "index_user_topics_on_user_id_and_topic_id", unique: true
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
    t.string "level"
    t.date "birthday"
    t.string "nationality"
    t.string "native_language"
    t.string "profile_pic"
    t.datetime "last_login_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "deactivate", default: false
    t.bigint "moodle_id"
    t.integer "kids", default: [], array: true
    t.boolean "changed_password", default: false
    t.integer "subjects", default: [], array: true
    t.datetime "graduated_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_hubs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "hub_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "main", default: true, null: false
    t.index ["hub_id"], name: "index_users_hubs_on_hub_id"
    t.index ["user_id"], name: "index_users_hubs_on_user_id"
    t.index ["user_id"], name: "index_users_hubs_on_user_id_main_true", unique: true, where: "(main = true)"
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
    t.text "lc_comment"
    t.text "reflection"
    t.index ["user_id", "week_id"], name: "index_weekly_goals_on_user_id_and_week_id", unique: true
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
    t.string "custom_topic"
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
  add_foreign_key "attendances", "users"
  add_foreign_key "communities", "sprint_goals"
  add_foreign_key "exam_dates", "subjects"
  add_foreign_key "exam_enroll_documents", "exam_enrolls"
  add_foreign_key "exam_enrolls", "moodle_timelines"
  add_foreign_key "form_interrogation_joins", "forms"
  add_foreign_key "form_interrogation_joins", "interrogations"
  add_foreign_key "friday_slots", "users", column: "lc_id"
  add_foreign_key "friday_slots", "users", column: "learner_id"
  add_foreign_key "friday_slots", "weekly_meetings"
  add_foreign_key "holidays", "users"
  add_foreign_key "hubps", "kdas"
  add_foreign_key "inis", "kdas"
  add_foreign_key "kdas", "users"
  add_foreign_key "kdas", "weeks"
  add_foreign_key "knowledges", "sprint_goals"
  add_foreign_key "learner_flags", "users"
  add_foreign_key "lws_timelines", "users"
  add_foreign_key "monday_slots", "users", column: "lc_id"
  add_foreign_key "monday_slots", "users", column: "learner_id"
  add_foreign_key "monday_slots", "weekly_meetings"
  add_foreign_key "moodle_timelines", "exam_dates"
  add_foreign_key "moodle_timelines", "subjects"
  add_foreign_key "moodle_timelines", "users"
  add_foreign_key "moodle_topics", "moodle_timelines"
  add_foreign_key "moodle_topics", "timelines"
  add_foreign_key "mots", "kdas"
  add_foreign_key "notes", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "p2ps", "kdas"
  add_foreign_key "report_activities", "communities"
  add_foreign_key "report_activities", "reports"
  add_foreign_key "report_activities", "skills"
  add_foreign_key "report_knowledges", "knowledges"
  add_foreign_key "report_knowledges", "reports"
  add_foreign_key "reports", "sprints"
  add_foreign_key "reports", "users"
  add_foreign_key "responses", "form_interrogation_joins"
  add_foreign_key "responses", "users"
  add_foreign_key "sdls", "kdas"
  add_foreign_key "skills", "sprint_goals"
  add_foreign_key "sprint_goals", "sprints"
  add_foreign_key "sprint_goals", "users"
  add_foreign_key "thursday_slots", "users", column: "lc_id"
  add_foreign_key "thursday_slots", "users", column: "learner_id"
  add_foreign_key "thursday_slots", "weekly_meetings"
  add_foreign_key "timeline_progresses", "timelines"
  add_foreign_key "timeline_progresses", "weeks"
  add_foreign_key "timelines", "exam_dates"
  add_foreign_key "timelines", "users"
  add_foreign_key "topics", "subjects"
  add_foreign_key "tuesday_slots", "users", column: "lc_id"
  add_foreign_key "tuesday_slots", "users", column: "learner_id"
  add_foreign_key "tuesday_slots", "weekly_meetings"
  add_foreign_key "user_topics", "timelines"
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
