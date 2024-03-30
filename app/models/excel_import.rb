class ExcelImport < ApplicationRecord
  has_one_attached :file
  after_commit :process_excel_file, on: [:create]

  private

  def process_excel_file
    # Ensure there's a file attached
    return unless file.attached?

    # Setup Roo to read the Excel file
    # Temporarily download the file for processing
    file.open(tmpdir: "/tmp") do |tempfile|
      workbook = Roo::Excelx.new(tempfile.path)

      # Example: Process the first sheet
      workbook.sheet(0).each_row_streaming(offset: 1) do |row|
        # Assuming the Excel file corresponds to the User model
        User.create(email: row[0].cell_value, name: row[1].cell_value)
      end
    end
  rescue => e
    Rails.logger.error "Failed to process Excel file: #{e.message}"
    # Handle exceptions, perhaps mark this import as failed, notify admins, etc.
  end
end
