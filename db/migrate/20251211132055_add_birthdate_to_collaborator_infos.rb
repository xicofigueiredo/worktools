class AddBirthdateToCollaboratorInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :collaborator_infos, :birthdate, :date
  end
end
