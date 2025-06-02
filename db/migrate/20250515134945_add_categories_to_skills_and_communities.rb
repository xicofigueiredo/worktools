class AddCategoriesToSkillsAndCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :skills, :categories, :string, array: true, default: []
    add_column :communities, :categories, :string, array: true, default: []
  end
end
