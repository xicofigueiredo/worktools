class CreateExcelImports < ActiveRecord::Migration[7.0]
  def change
    create_table :excel_imports do |t|

      t.timestamps
    end
  end
end
