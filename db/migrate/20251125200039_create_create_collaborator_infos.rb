class CreateCreateCollaboratorInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :collaborator_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :can_teach_pt_plus, default: false
      t.boolean :can_teach_remote, default: false

      t.timestamps
    end

    remove_column :users, :can_teach_pt_plus, :boolean, default: false
  end
end
