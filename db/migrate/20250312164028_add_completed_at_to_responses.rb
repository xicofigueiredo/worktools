class AddCompletedAtToResponses < ActiveRecord::Migration[7.0]
  def change
    add_column :responses, :completed_at, :datetime
  end
end
