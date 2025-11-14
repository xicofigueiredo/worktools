class AddPlatformFieldsToLearnerInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_infos, :platform_username, :string
    add_column :learner_infos, :platform_password, :string
  end
end
