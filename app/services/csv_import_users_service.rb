class CsvImportUsersService
  require 'csv'

  def call(file)
    file = File.open(file)
    csv = CSV.parse(file, headers: true, col_sep: ';')
    csv.each do |row|
      user_hash = {}
      user_hash[:full_name] = row['full_name']
      user_hash[:email] = row['email']
      user_hash[:role] = row['role']
      User.find_or_create_by!(user_hash)
      # binding.b
      # p row
    end
  end
end
