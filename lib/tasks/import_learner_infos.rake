require 'csv'
require 'set'
require 'i18n' unless defined?(I18n)
def normalize_name_for_match(s)
  return "" if s.nil?
  t = s.to_s.dup
  t = I18n.transliterate(t) if defined?(I18n)
  t = t.downcase
  t = t.gsub(/[^\w\s-]/, '')
  t = t.gsub(/\s+/, ' ').strip
  t
end
def levenshtein(a, b)
  a = a.to_s
  b = b.to_s
  return b.length if a.length == 0
  return a.length if b.length == 0
  v0 = (0..b.length).to_a
  v1 = Array.new(b.length + 1)
  a.length.times do |i|
    v1[0] = i + 1
    b.length.times do |j|
      cost = (a[i] == b[j]) ? 0 : 1
      v1[j + 1] = [
        v1[j] + 1,
        v0[j + 1] + 1,
        v0[j] + cost
      ].min
    end
    v0 = v1.dup
  end
  v1[b.length]
end
def resolve_hub_ambiguity(raw_fragment, frag_norm, candidates)
  @num_all_hubs ||= @cached_hubs.size
  is_ambiguous = candidates.size < @num_all_hubs
  candidates = candidates.sort_by(&:name)
  puts "\n#{is_ambiguous ? 'Ambiguous match' : 'No match found'} for hub fragment: #{raw_fragment} (normalized: #{frag_norm})"
  puts "Candidates:"
  candidates.each_with_index do |h, i|
    puts "#{i+1}. #{h.name} (id: #{h.id})"
  end
  puts "0. None (skip)"
  print "Choose the correct hub (0-#{candidates.size}): "
  choice = gets.chomp.to_i
  if choice == 0 || choice > candidates.size
    @hub_mappings[frag_norm] = nil
    return nil
  else
    selected = candidates[choice - 1]
    @hub_mappings[frag_norm] = selected
    return selected
  end
end
def find_best_hub_match(raw_hub_fragment)
  return nil if raw_hub_fragment.nil? || raw_hub_fragment.strip == ''
  frag_norm = normalize_name_for_match(raw_hub_fragment)
  @cached_hubs ||= Hub.all.map { |h| [h, normalize_name_for_match(h.name)] }
  @hub_mappings ||= {}
  if @hub_mappings.has_key?(frag_norm)
    return @hub_mappings[frag_norm]
  end
  # 1) exact normalized match
  @cached_hubs.each do |h, name_norm|
    if name_norm == frag_norm
      @hub_mappings[frag_norm] = h
      return h
    end
  end
  # 2) ends_with or contains
  @cached_hubs.each do |h, name_norm|
    if frag_norm.end_with?(name_norm) || name_norm.end_with?(frag_norm) || frag_norm.include?(name_norm) || name_norm.include?(frag_norm)
      @hub_mappings[frag_norm] = h
      return h
    end
  end
  # 3) token overlap
  frag_tokens = Set.new(frag_norm.split)
  candidates = []
  best_score = 0.0
  @cached_hubs.each do |h, name_norm|
    tokens = Set.new(name_norm.split)
    common = (frag_tokens & tokens).size.to_f
    score = common / [tokens.size, frag_tokens.size].max
    if score > best_score
      best_score = score
      candidates = [h]
    elsif score == best_score
      candidates << h
    end
  end
  if best_score >= 0.6
    if candidates.size == 1
      @hub_mappings[frag_norm] = candidates.first
      return candidates.first
    else
      return resolve_hub_ambiguity(raw_hub_fragment, frag_norm, candidates)
    end
  end
  # 4) Levenshtein fallback
  distances = []
  @cached_hubs.each do |h, name_norm|
    d = levenshtein(frag_norm, name_norm)
    distances << [h, name_norm, d]
  end
  distances.sort_by! { |arr| arr[2] }
  min_d = distances[0][2]
  top = distances.select { |arr| arr[2] == min_d }
  top_candidates = top.map { |arr| arr[0] }
  top_name_norm = top[0][1]
  if top_candidates.size > 1
    return resolve_hub_ambiguity(raw_hub_fragment, frag_norm, top_candidates)
  else
    top_h = top_candidates.first
    if min_d <= 3 || min_d.to_f <= ([frag_norm.length, top_name_norm.length].max * 0.25)
      @hub_mappings[frag_norm] = top_h
      return top_h
    end
  end
  # No match: prompt from all hubs
  all_candidates = @cached_hubs.map(&:first)
  resolve_hub_ambiguity(raw_hub_fragment, frag_norm, all_candidates)
end
# Curriculum normalization mapping
def normalize_curriculum(raw_curriculum)
  return nil if raw_curriculum.nil? || raw_curriculum.to_s.strip.empty?
  curriculum_map = {
    'american curriculum (fia)' => 'American Curriculum',
    'british curriculum' => 'British Curriculum',
    'alternative (own) curriculum' => 'Own Curriculum',
    'up business' => 'UP Business',
    'american curriculum (ecampus)' => 'Own Curriculum',
    'up sports and leisure' => 'UP Sports Management',
    'unsure' => nil,
    'up computing' => 'UP Computing',
    'american curriculum (flvs)' => 'Own Curriculum',
    'up business (bga)' => 'UP Business',
    'esl course' => 'ESL Course',
    'portuguese curriculum' => 'Portuguese Curriculum',
    'american curriculum' => 'American Curriculum',
    'up business management' => 'UPx Business',
    'own curriculum' => 'Own Curriculum',
    'upx business management' => 'UPx Business',
    'up business ; upx business management' => 'UPx Business',
    'up business (genex)' => 'UP Business (GENEX)'
  }
  normalized_key = raw_curriculum.to_s.strip.downcase
  mapped = curriculum_map[normalized_key]
  return mapped if mapped || curriculum_map.key?(normalized_key)
  # Fallback: if it contains "up business" variations
  if normalized_key.include?('upx') && normalized_key.include?('business')
    return 'UPx Business'
  elsif normalized_key.include?('up') && normalized_key.include?('business')
    return 'UP Business'
  elsif normalized_key.include?('ecampus') || normalized_key.include?('flvs')
    return 'Own Curriculum'
  end
  # Return original if no mapping found
  raw_curriculum.to_s.strip
end
# Grade normalization based on curriculum
def normalize_grade(raw_grade, curriculum)
  return nil if raw_grade.nil? || raw_grade.to_s.strip.empty?
  return nil if curriculum.nil?
  grade_str = raw_grade.to_s.strip
  # Extract year/grade number from strings like "US Grade 12 (UK Year 13)"
  # Try to match the pattern and extract both US and UK values
  us_match = grade_str.match(/US\s+(?:Grade|Year)\s+(\d+)/i)
  uk_match = grade_str.match(/UK\s+Year\s+(\d+)/i)
  pt_match = grade_str.match(/PT\s+Year\s+(\d+)/i)
  # Also handle simple numeric grades
  simple_number = grade_str.match(/^\d+$/) ? grade_str.to_i : nil
  case curriculum
  when 'British Curriculum'
    if uk_match
      year_num = uk_match[1].to_i
      return "UK Year #{year_num}"
    elsif us_match
      # Convert US to UK using mapping
      us_grade = us_match[1].to_i
      uk_year = case us_grade
                when 12 then 13
                when 11 then 12
                when 10 then 11
                when 9 then 10
                when 8 then 9
                when 7 then 8
                else us_grade
                end
      return "UK Year #{uk_year}"
    elsif simple_number
      return "UK Year #{simple_number}"
    end
  when 'American Curriculum'
    if us_match
      grade_num = us_match[1].to_i
      return "US Year #{grade_num}"
    elsif uk_match
      # Convert UK to US using mapping
      uk_year = uk_match[1].to_i
      us_grade = case uk_year
                 when 13 then 12
                 when 12 then 11
                 when 11 then 10
                 when 10 then 9
                 when 9 then 8
                 when 8 then 7
                 else uk_year
                 end
      return "US Year #{us_grade}"
    elsif simple_number
      return "US Year #{simple_number}"
    end
  when 'Portuguese Curriculum'
    if pt_match
      year_num = pt_match[1].to_i
      return "PT Year #{year_num}"
    elsif us_match
      # Convert US to PT using mapping (PT follows similar to UK)
      us_grade = us_match[1].to_i
      pt_year = case us_grade
                when 12 then 13
                when 11 then 12
                when 10 then 11
                when 9 then 10
                when 8 then 9
                when 7 then 8
                else us_grade
                end
      return "PT Year #{pt_year}"
    elsif simple_number
      return "PT Year #{simple_number}"
    end
  when 'UP Business', 'UPx Business', 'UP Computing', 'UP Sports Management'
    # UP programs use Level system
    if grade_str.match(/Level\s+(\d+)/i)
      level_num = $1.to_i
      return "Level #{level_num}"
    elsif us_match
      # Map US grades to UP levels (approximate)
      us_grade = us_match[1].to_i
      level = case us_grade
              when 12 then 6
              when 11 then 5
              when 10 then 4
              when 9 then 3
              else nil
              end
      return "Level #{level}" if level
    elsif simple_number && simple_number >= 3 && simple_number <= 6
      return "Level #{simple_number}"
    end
  when 'Own Curriculum', 'ESL Course'
    # Own Curriculum and ESL don't have normalized grades
    return nil
  end
  # If no mapping found, return original
  raw_grade
end
def parse_discount(value)
  return nil if value.nil? || value.to_s.strip.empty?
  value.to_s.gsub(/[^\d,\.\-]/, '').gsub(',', '.').to_f
end
def parse_scholarship(value)
  return nil if value.nil? || value.to_s.strip.empty?
  value.to_s.gsub(/[^\d,\.\-]/, '').gsub(',', '.').to_f
end
namespace :admissions do
  desc "Import admissions CSV into learner_infos with curriculum and grade normalization"
  task import_learner_infos: :environment do
    csv_file_path = Rails.root.join('lib', 'tasks', 'admissions_list.csv')
    unless File.exist?(csv_file_path)
      puts "CSV file not found at #{csv_file_path}"
      exit 1
    end
    dry_run = ENV['DRY_RUN'].to_s.downcase == 'true'
    ARGV.clear
    puts "Starting verbose import (DRY_RUN=#{dry_run})"
    puts "CSV: #{csv_file_path}"
    puts
    to_utf8 = lambda do |val|
      return nil if val.nil?
      s = val.is_a?(String) ? val.dup : val.to_s
      return s if s.encoding == Encoding::UTF_8 && s.valid_encoding?
      encodings_to_try = ['UTF-8', 'Windows-1252', 'ISO-8859-1', 'ISO-8859-15']
      encodings_to_try.each do |enc|
        begin
          candidate = s.dup.force_encoding(enc)
          return candidate.encode('UTF-8')
        rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError
          next
        end
      end
      begin
        return s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      rescue
        return s.force_encoding('BINARY').encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      end
    end
    nilish = ->(v) { v.nil? || v.to_s.strip == '' || %w[n/a na null].include?(v.to_s.strip.downcase) }
    parse_date = ->(v) do
      return nil if nilish.call(v)
      s = v.to_s.strip
      if s.match?(/^\d+$/)
        begin
          serial = s.to_i
          Date.new(1899, 12, 30) + serial
        rescue
          nil
        end
      else
        begin
          Date.parse(s) rescue nil
        end
      end
    end
    parse_int = ->(v) do
      return nil if nilish.call(v)
      cleaned = v.to_s.gsub(/[^\d\-]/, '')
      cleaned == '' ? nil : cleaned.to_i
    end
    parse_decimal = ->(v) do
      return nil if nilish.call(v)
      s = v.to_s.strip.gsub(/[^\d,\.\-]/, '')
      s = s.gsub(',', '.')
      s == '' ? nil : s.to_f
    end
    normalize = ->(s) { to_utf8.call(s).to_s.strip.downcase.gsub(/\s+/, ' ') }
    fetch = lambda do |row, *candidates|
      headers_norm = row.headers.map { |h| [normalize.call(h), h] }.to_h
      candidates.each do |cand|
        return to_utf8.call(row[cand]) if row.headers.include?(cand)
        key = normalize.call(cand)
        if headers_norm.key?(key)
          raw = row[headers_norm[key]]
          return to_utf8.call(raw)
        end
      end
      nil
    end
    FIELD_MAP = {
      status: ['Status'],
      programme: ['Programme (Section 2)', 'Programme'],
      full_name: ["Learner's Full Name (Section 5)", "Learner's Full Name"],
      curriculum_course_option: ['Curriculum/Course Option (Section 3)', 'Curriculum/Course Option'],
      grade_year: ['Grade/Year (Section 4)', 'Grade/Year'],
      start_date: ['Start Date'],
      transfer_of_programme_date: ['Transfer of Programme Date'],
      end_date: ['End Date'],
      end_day_communication: ['End Day Communication'],
      birthdate: ['Birthdate (5)', 'Birthdate'],
      personal_email: ['Personal Email (5)', 'Personal Email'],
      institutional_email: ['InstitutionalEmail', 'Institutional Email'],
      phone_number: ["Learner's Phone Number (5)", "Learner's Phone Number"],
      nationality: ["Learner's Nationality (5)", 'Nationality'],
      id_information: ["Learner's ID Information (5)"],
      fiscal_number: ["Learner's Fiscal Number (5)"],
      english_proficiency: ['English Proficiency (5)', 'English Proficiency'],
      home_address: ['Home Address (5: Street Address + City + Postal Code + Country)', 'Home Address'],
      gender: ["Learner's Gender (5)", 'Gender'],
      use_of_image_authorisation: ['Use of Image Authorisation (Section 7)'],
      emergency_protocol_choice: ['Emergency Protocol Choice (Section 9)'],
      parent1_full_name: ['Parent 1 - Full Name (Section 6)'],
      parent1_email: ['Parent 1 - Email (6)', 'Parent 1 - Email'],
      parent1_phone_number: ['Parent 1 - Phone Number (6)'],
      parent1_id_information: ['Parent 1 - ID Information (6)'],
      parent2_full_name: ['Parent 2 - Full Name (6)'],
      parent2_email: ['Parent 2 - Email (6)'],
      parent2_phone_number: ['Parent 2 - Phone Number (6)'],
      parent2_id_information: ['Parent 2 - ID Information (6)'],
      parent2_info_not_to_be_contacted: ['Parent 2 - Info (not to be contacted)'],
      registration_renewal: ['Registrarion Renewal', 'Registration Renewal'],
      registration_renewal_date: ['Registration Renewal Date'],
      deposit: ['Deposit'],
      sponsor: ['Sponsor'],
      payment_plan: ['Payment Plan (Section 8)', 'Payment Plan'],
      monthly_tuition: ['Monthly Tuition'],
      discount_mt: ['Discount MT'],
      scholarship: ['Scholarship'],
      billable_fee_per_month: ['Billable Fee/Month'],
      scholarship_percentage: ['Scholarship %'],
      admission_fee: ['Admission Fee'],
      discount_af: ['Discount AF'],
      billable_af: ['Billable AF'],
      registering_school_pt_plus: ['Registering School (In case of PT+)'],
      previous_schooling: ['Previous Schooling'],
      previous_school_status: ['Previous School Status (Section 4)'],
      previous_school_name: ['Previous School Name (Section 4)'],
      previous_school_email: ['Previous School Email (Section 4)'],
      withdrawal_category: ['Withdrawal Category'],
      withdrawal_reason: ['Withdrawal Reason'],
    }.freeze
    parse_field = lambda do |value, key|
      return nil if nilish.call(value)
      case key
      when :start_date, :transfer_of_programme_date, :end_date, :birthdate, :registration_renewal_date
        parse_date.call(value)
      when :monthly_tuition, :billable_fee_per_month, :scholarship_percentage, :admission_fee, :discount_af, :billable_af
        parse_decimal.call(value)
      when :registration_renewal, :fiscal_number
        parse_int.call(value)
      when :english_proficiency, :use_of_image_authorisation, :emergency_protocol_choice
        v = value.to_s.strip.downcase
        return true if %w[true t yes y 1].include?(v)
        return false if %w[false f no n 0].include?(v)
        nil
      else
        to_utf8.call(value).to_s.strip
      end
    end
    generate_student_number = lambda do |year, max_retries = 5|
      raise ArgumentError, "invalid year #{year}" unless year.is_a?(Integer) && year > 0
      attempt = 0
      begin
        attempt += 1
        student_number = nil
        ActiveRecord::Base.transaction(requires_new: true) do
          year_min = year * 10_000
          year_max = year_min + 9_999
          max_sn = LearnerInfo.where(student_number: year_min..year_max).maximum(:student_number)
          seq = max_sn.nil? ? 1 : (max_sn % 10_000) + 1
          raise "year #{year} exhausted" if seq > 9_999
          candidate = year_min + seq
          if LearnerInfo.exists?(student_number: candidate)
            raise ActiveRecord::RecordNotUnique, "student_number #{candidate} exists"
          end
          student_number = candidate
        end
        return student_number
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid
        retry if attempt < max_retries
        raise
      end
    end
    total = 0
    created = 0
    updated = 0
    no_changes = 0
    errors = 0
    sample_table = CSV.read(csv_file_path, headers: true, encoding: 'bom|utf-8')
    puts "Detected CSV headers (#{sample_table.headers.size}):"
    sample_table.headers.each_with_index { |h, i| puts "  #{i + 1}. #{to_utf8.call(h).inspect}" }
    puts
    CSV.foreach(csv_file_path, headers: true, encoding: 'bom|utf-8') do |row|
      total += 1
      row_num = total + 1
      begin
        attrs = {}
        FIELD_MAP.each do |attr, header_candidates|
          raw = fetch.call(row, *header_candidates)
          parsed = parse_field.call(raw, attr)
          attrs[attr] = parsed
        end
        # Programme normalization
        if attrs[:programme].present?
          long_to_short = {
            normalize.call('In-person (with Hub access): Secondary Education (Grades 6 to 12)') => 'In-Person: Secondary Education',
            normalize.call('In-person (with Hub access): UP Programme (Higher Education)') => 'In-Person: UP Programme',
            normalize.call('Online Only (no Hub access): Secondary Education (Grades 6 to 12)') => 'Online: Secondary Education',
            normalize.call('Online Only (no Hub access): UP Programme (Higher Education)') => 'Online: UP Programme',
            normalize.call('BAS Programme (Academy of Sports)') => 'BAS Programme',
            normalize.call('In-person (with Hub access): Own Curriculum') => 'Own Curriculum'
          }
          incoming_key = normalize.call(attrs[:programme])
          if long_to_short.key?(incoming_key)
            old = attrs[:programme]
            attrs[:programme] = long_to_short[incoming_key]
            puts "Row #{row_num}: NORMALIZED programme - #{old.inspect} -> #{attrs[:programme].inspect}"
          end
        end
        # Curriculum normalization
        if attrs[:curriculum_course_option].present?
          old_curriculum = attrs[:curriculum_course_option]
          normalized_curriculum = normalize_curriculum(old_curriculum)
          if normalized_curriculum != old_curriculum
            attrs[:curriculum_course_option] = normalized_curriculum
            puts "Row #{row_num}: NORMALIZED curriculum - #{old_curriculum.inspect} -> #{normalized_curriculum.inspect}"
          end
        end
        # Grade normalization based on curriculum
        if attrs[:grade_year].present? && attrs[:curriculum_course_option].present?
          old_grade = attrs[:grade_year]
          normalized_grade = normalize_grade(old_grade, attrs[:curriculum_course_option])
          if normalized_grade.nil? || normalized_grade != old_grade
            attrs[:grade_year] = normalized_grade
            puts "Row #{row_num}: NORMALIZED grade - #{old_grade.inspect} -> #{normalized_grade.inspect} (curriculum: #{attrs[:curriculum_course_option]})"
          end
        end
        start_date = attrs[:start_date]
        if start_date.present?
          year = start_date.year
          student_number = generate_student_number.call(year)
          attrs[:student_number] = student_number
        else
          attrs[:student_number] = nil
        end
        # Split into learner_info_attrs and finance_attrs
        finance_keys = [:deposit, :sponsor, :payment_plan, :monthly_tuition, :discount_mt, :scholarship, :billable_fee_per_month, :scholarship_percentage, :admission_fee, :discount_af, :billable_af, :registration_renewal]
        learner_info_attrs = attrs.except(*finance_keys)
        # Convert absolute discounts and scholarships to percentages
        monthly_fee = attrs[:monthly_tuition].to_f
        admission_fee = attrs[:admission_fee].to_f
        discount_mf_absolute = parse_discount(attrs[:discount_mt])
        discount_mf_percent = if monthly_fee > 0 && discount_mf_absolute.present?
                                (discount_mf_absolute.to_f / monthly_fee * 100).round(2)
                              else
                                0.0
                              end
        scholarship_absolute = parse_scholarship(attrs[:scholarship])
        scholarship_percent = if monthly_fee > 0 && scholarship_absolute.present?
                                (scholarship_absolute.to_f / monthly_fee * 100).round(2)
                              else
                                0.0
                              end
        discount_af_absolute = parse_discount(attrs[:discount_af])
        discount_af_percent = if admission_fee > 0 && discount_af_absolute.present?
                                (discount_af_absolute.to_f / admission_fee * 100).round(2)
                              else
                                0.0
                              end
        renewal_fee = attrs[:registration_renewal]
        discount_rf = 0
        billable_rf = renewal_fee.to_i - discount_rf
        finance_attrs = {
          payment_plan: attrs[:payment_plan],
          monthly_fee: attrs[:monthly_tuition],
          discount_mf: discount_mf_percent,
          scholarship: scholarship_percent,
          billable_mf: attrs[:billable_fee_per_month],
          admission_fee: attrs[:admission_fee],
          discount_af: discount_af_percent,
          billable_af: attrs[:billable_af],
          renewal_fee: renewal_fee,
          discount_rf: discount_rf,
          billable_rf: billable_rf
        }
        ident = attrs[:institutional_email].presence || "#{attrs[:full_name].to_s[0..40]}|#{attrs[:birthdate].to_s}"
        raw_hub_cell = fetch.call(row, 'Hub Location (Section 2)', 'Hub Location', 'Hub')
        raw_hub_for_logging = to_utf8.call(raw_hub_cell).to_s.strip
        hub_fragment = nil
        if raw_hub_cell.present?
          s = raw_hub_cell.to_s
          hub_fragment = s.include?('-') ? s.split('-', 2).last.to_s.strip : s.strip
        end
        matched_hub = find_best_hub_match(hub_fragment)
        found = nil
        if attrs[:institutional_email].present?
          found = LearnerInfo.find_by(institutional_email: attrs[:institutional_email])
        end
        if found.nil? && attrs[:full_name].present? && attrs[:birthdate].present?
          found = LearnerInfo.find_by(full_name: attrs[:full_name], birthdate: attrs[:birthdate])
        end
        li_var = nil
        begin
          if found
            diffs = {}
            learner_info_attrs.each do |k, v|
              current = found.send(k)
              cur_s = current.respond_to?(:strftime) ? current.to_s : (current.nil? ? '' : current.to_s)
              new_s = v.respond_to?(:strftime) ? v.to_s : (v.nil? ? '' : v.to_s)
              diffs[k] = { from: cur_s, to: new_s } if cur_s != new_s
            end
            if diffs.empty?
              no_changes += 1
              puts "Row #{row_num}: NO CHANGES for #{ident}"
              li_var = found
            else
              if dry_run
                updated += 1
                puts "Row #{row_num}: WOULD UPDATE #{ident} - changes: #{diffs.keys.join(', ')}"
                li_var = found
              else
                found.assign_attributes(learner_info_attrs)
                found.save!(validate: false)
                updated += 1
                puts "Row #{row_num}: UPDATED #{ident} (id=#{found.id}) - changes: #{diffs.keys.join(', ')}"
                li_var = found
              end
            end
          else
            if dry_run
              created += 1
              puts "Row #{row_num}: WOULD CREATE #{ident} student_number=#{learner_info_attrs[:student_number].inspect}"
            else
              li_var = LearnerInfo.new(learner_info_attrs)
              li_var.data_validated = (attrs[:status] != "In progress")
              if attrs[:institutional_email].present?
                u = User.find_by(email: attrs[:institutional_email])
                li_var.user = u if u
              end
              li_var.skip_email_validation = true
              li_var.save!
              created += 1
              puts "Row #{row_num}: CREATED id=#{li_var.id} #{ident} student_number=#{learner_info_attrs[:student_number].inspect} data_validated=#{li_var.data_validated}"
            end
          end
          # Handle hub association
          if !dry_run && li_var && matched_hub
            li_var.update!(hub_id: matched_hub.id)
            puts "Row #{row_num}: associated #{ident} (id=#{li_var.id}) to hub #{matched_hub.name} (id=#{matched_hub.id})"
          elsif !dry_run && li_var && !matched_hub
            puts "Row #{row_num}: couldn't associate #{ident} (id=#{li_var.id}) to the \"Hub Location (Section 2)\" \"#{raw_hub_for_logging}\""
          elsif dry_run && matched_hub
            puts "Row #{row_num}: WOULD associate #{ident} to hub #{matched_hub.name} (id=#{matched_hub.id})"
          elsif dry_run && !matched_hub
            puts "Row #{row_num}: WOULD NOT associate #{ident} to the \"Hub Location (Section 2)\" \"#{raw_hub_for_logging}\""
          end
          # Handle learner_finances
          if dry_run
            puts "Row #{row_num}: WOULD HANDLE finances for #{ident}"
          else
            if li_var
              lf = li_var.learner_finance || LearnerFinance.new(learner_info: li_var)
              old_finance_attrs = lf.attributes.slice(*finance_attrs.keys.map(&:to_s))
              finance_diffs = {}
              finance_attrs.each do |k, v|
                current = old_finance_attrs[k.to_s]
                cur_s = current.nil? ? '' : current.to_s
                new_s = v.nil? ? '' : v.to_s
                finance_diffs[k] = { from: cur_s, to: new_s } if cur_s != new_s
              end
              if finance_diffs.any?
                lf.assign_attributes(finance_attrs)
                lf.save!(validate: false)
                puts "Row #{row_num}: FINANCE UPDATED for #{ident} (id=#{li_var.id}) - changes: #{finance_diffs.keys.join(', ')}"
              else
                puts "Row #{row_num}: FINANCE NO CHANGES for #{ident} (id=#{li_var.id})"
              end
            end
          end
        rescue => e
          errors += 1
          puts "Row #{row_num}: ERROR for #{ident} -> #{e.class}: #{e.message}"
          e.backtrace.first(5).each { |bt| puts "  #{bt}" }
          Rails.logger.error "Admissions import error (row #{row_num}): #{e.full_message}"
        end
      end
    end
    puts
    puts "Import finished."
    puts "Total rows processed: #{total}"
    puts "Created: #{created}"
    puts "Updated: #{updated}"
    puts "No changes: #{no_changes}"
    puts "Errors: #{errors}"
    puts "DRY_RUN=#{dry_run}"
  end
end
