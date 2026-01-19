class CreateCscDiplomas < ActiveRecord::Migration[7.0]
  def change
    create_table :csc_diplomas do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :issued, default: false, null: false

      t.timestamps
    end
  end
end
