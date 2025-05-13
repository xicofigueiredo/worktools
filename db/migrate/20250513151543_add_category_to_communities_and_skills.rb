class AddCategoryToCommunitiesAndSkills < ActiveRecord::Migration[7.0]
  def change
    add_column :communities, :category, :string
    add_column :skills, :category, :string
  end
end
