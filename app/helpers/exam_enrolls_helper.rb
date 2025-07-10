module ExamEnrollsHelper
  def get_permitted_fields(current_user)
    case current_user.role
    when 'admin'
      :all
    when 'cm'
      ['pre_registration_exception_cm_approval',
       'pre_registration_exception_cm_comment',
       'failed_mock_exception_cm_approval',
       'failed_mock_exception_cm_comment',
       'extension_cm_approval',
       'extension_cm_comment']
    when 'rm'
      ['pre_registration_exception_dc_approval',
       'pre_registration_exception_dc_comment',
       'failed_mock_exception_dc_approval',
       'failed_mock_exception_dc_comment',
       'extension_dc_approval',
       'extension_dc_comment']
    when 'edu'
      ['pre_registration_exception_edu_approval',
       'pre_registration_exception_edu_comment',
       'failed_mock_exception_edu_approval',
       'failed_mock_exception_edu_comment',
       'extension_edu_approval',
       'extension_edu_comment']
    when 'lc'
      :lc_access
    else
      []
    end
  end

  def field_disabled?(field_name, user, exam_enroll = nil)
    permitted_fields = get_permitted_fields(user)
    return false if permitted_fields == :all

    if permitted_fields == :lc_access
      # For LCs: disable approval/comment fields
      return true if field_name.to_s.match?(/(cm|dc|edu)_(approval|comment)/)

      # ALWAYS disable subject_name for LCs
      return true if field_name.to_s == 'subject_name'

      # For new exam enrollments, allow editing of qualification, code, and personalized_exam_date
      if exam_enroll&.new_record? || exam_enroll.nil?
        return false if ['qualification', 'code', 'personalized_exam_date'].include?(field_name.to_s)
      else
        # For existing exam enrollments, disable qualification and code, but allow personalized_exam_date
        return true if ['qualification', 'code'].include?(field_name.to_s)
        return false if field_name.to_s == 'personalized_exam_date'
      end

      return false
    end

    # For other roles: disable if not in their permitted fields
    !permitted_fields.include?(field_name.to_s)
  end
end
