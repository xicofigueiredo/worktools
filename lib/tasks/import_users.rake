# lib/tasks/import_users.rake
require 'roo'

namespace :import do
  desc "Import users from an Excel file"
  task users: :environment do
    file_path = Rails.root.join('lib', 'assets', 'users.xlsx')
    xlsx = Roo::Excelx.new(file_path)

    xlsx.sheet(0).each_row_streaming(offset: 1) do |row|
      User.create!(
        full_name:     row[0].cell_value,
        email:         row[1].cell_value,
        password:      row[2].cell_value, # Remember to handle password securely
        role:          row[3].cell_value,
        category:      row[4].cell_value,
        topics_balance: row[5].cell_value
      )
    end
  end
end
