require 'csv'

namespace :pricing do
  desc "Import pricing tiers from CSV"
  task import: :environment do
    csv_file_path = Rails.root.join('lib', 'tasks', 'pricing_tiers.csv')

    unless File.exist?(csv_file_path)
      puts "Error: CSV file not found at #{csv_file_path}"
      exit
    end

    # Group rows by unique combination
    grouped_data = {}

    CSV.foreach(csv_file_path, headers: true, col_sep: ';', encoding: 'UTF-8:UTF-8', liberal_parsing: true) do |row|
      # Strip BOM and whitespace from headers
      row = row.to_h.transform_keys { |k| k.to_s.strip.gsub(/^\xEF\xBB\xBF/, '') }
      row = CSV::Row.new(row.keys, row.values)
      # Create a unique key for grouping
      key = [
        row['Model'],
        row['Country'],
        row['Currency'],
        row['Hub Type'],
        row['Specific Hub'],
        row['Curriculum']
      ].map(&:to_s).join('|')

      grouped_data[key] ||= {
        model: row['Model'],
        country: row['Country'],
        currency: row['Currency'],
        hub_type: row['Hub Type'],
        specific_hub: row['Specific Hub'],
        curriculum: row['Curriculum'],
        admission_fee: nil,
        monthly_fee: nil,
        renewal_fee: nil,
        invoice_recipient: row['Invoice'],
        notes: row['Notes']
      }

      # Map fee types to the correct field
      fee_type = row['Fee']&.strip
      fee_value = row['Value']&.to_i

      case fee_type
      when "Admissions Fee", "Level Admissions Fee"
        grouped_data[key][:admission_fee] = fee_value
      when "Annual Registration Fee"
        grouped_data[key][:renewal_fee] = fee_value
      when "Monthly Fee"
        grouped_data[key][:monthly_fee] = fee_value
      else
        puts "Warning: Unknown fee type '#{fee_type}' for key #{key}"
      end

      # Update invoice and notes if they exist (keep latest non-nil value)
      grouped_data[key][:invoice_recipient] = row['Invoice'] if row['Invoice'].present?
      grouped_data[key][:notes] = row['Notes'] if row['Notes'].present?
    end

    # Now insert into database
    PricingTier.transaction do
      PricingTier.delete_all # Clear existing data

      grouped_data.each do |key, data|
        PricingTier.create!(
          model: data[:model],
          country: data[:country],
          currency: data[:currency],
          hub_type: data[:hub_type],
          specific_hub: data[:specific_hub],
          curriculum: data[:curriculum],
          admission_fee: data[:admission_fee],
          monthly_fee: data[:monthly_fee],
          renewal_fee: data[:renewal_fee],
          invoice_recipient: data[:invoice_recipient],
          notes: data[:notes]
        )
      end
    end

    puts "Successfully imported #{grouped_data.count} pricing tiers"
  end
end
