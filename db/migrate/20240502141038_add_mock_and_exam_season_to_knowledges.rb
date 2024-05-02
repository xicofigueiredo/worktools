class AddMockAndExamSeasonToKnowledges < ActiveRecord::Migration[7.0]
  def change
    add_column :knowledges, :mock50, :string
    add_column :knowledges, :mock100, :string
    add_column :knowledges, :exam_season, :string
  end
end
