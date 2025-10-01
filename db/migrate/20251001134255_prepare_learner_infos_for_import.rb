class PrepareLearnerInfosForImport < ActiveRecord::Migration[7.0]
  def change
    # 1) Make user_id nullable and ensure a non-unique index exists
    if column_exists?(:learner_infos, :user_id)
      # Remove unique index on user_id if it exists
      if index_exists?(:learner_infos, :user_id, unique: true)
        remove_index :learner_infos, column: :user_id
      end

      # Add a normal index if none exists (safe no-op if present)
      add_index :learner_infos, :user_id unless index_exists?(:learner_infos, :user_id)
      change_column_null :learner_infos, :user_id, true
    end

    # 2) Replace student_number index with a unique partial index (student_number IS NOT NULL)
    # Remove existing student_number index (non-unique) if present
    if index_exists?(:learner_infos, :student_number)
      # remove by column (will remove first matching index)
      remove_index :learner_infos, column: :student_number
    end

    # Add unique partial index to enforce uniqueness for non-null student numbers
    # (Postgres supports WHERE clause; if you use another DB, remove `where:` and consider full unique index)
    unless index_exists?(:learner_infos, :student_number, unique: true)
      add_index :learner_infos, :student_number,
                unique: true,
                name: "index_learner_infos_on_student_number_unique",
                where: "student_number IS NOT NULL"
    end

    # 3) Add index on institutional_email to speed lookups (non-unique)
    add_index :learner_infos, :institutional_email unless index_exists?(:learner_infos, :institutional_email)

    # 4) Add index on start_date (useful for year-based queries)
    add_index :learner_infos, :start_date unless index_exists?(:learner_infos, :start_date)
  end
end
