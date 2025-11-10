class AddWeekToAttendances < ActiveRecord::Migration[7.0]
  def up
    # First add the column as nullable
    add_reference :attendances, :week, null: true, foreign_key: true
    
    # Update existing records using a single SQL query
    execute <<-SQL
      UPDATE attendances 
      SET week_id = weeks.id 
      FROM weeks 
      WHERE attendances.week_id IS NULL 
      AND attendances.attendance_date >= weeks.start_date 
      AND attendances.attendance_date <= weeks.end_date
    SQL
    
    # Handle any remaining null values by creating a default week or deleting orphaned records
    # For now, let's delete attendances that don't have a matching week
    execute <<-SQL
      DELETE FROM attendances WHERE week_id IS NULL
    SQL
    
    # Now make it non-nullable
    change_column_null :attendances, :week_id, false
  end
  
  def down
    remove_reference :attendances, :week, foreign_key: true
  end
end
