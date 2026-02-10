class LearnerDocumentPermission
  attr_reader :user, :record, :role

  DOC_VIEW_BY_ROLE = {
    'admin' => %w[contract special_needs last_term_report proof_of_payment learner_id parent_id medical_form letter_of_interest picture credentials exam_certificates transfer],
    'admissions' => %w[contract special_needs last_term_report proof_of_payment learner_id parent_id medical_form letter_of_interest picture credentials exam_certificates transfer],
    'edu' => %w[special_needs last_term_report medical_form letter_of_interest picture credentials exam_certificates transfer],
    'finance' => %w[contract special_needs last_term_report proof_of_payment learner_id parent_id medical_form letter_of_interest picture credentials exam_certificates transfer],
    'ops' => %w[contract special_needs last_term_report proof_of_payment learner_id parent_id medical_form letter_of_interest picture credentials exam_certificates transfer],
    'it' => %w[special_needs last_term_report medical_form letter_of_interest picture credentials exam_certificates transfer],
    'lc' => %w[special_needs last_term_report medical_form letter_of_interest picture credentials exam_certificates transfer],
    'rm' => %w[special_needs last_term_report medical_form letter_of_interest picture credentials exam_certificates transfer],
    'exams' => %w[special_needs last_term_report medical_form letter_of_interest picture credentials exam_certificates transfer]
  }.freeze

  DOC_EDIT_BY_ROLE = {
    'admin' => DOC_VIEW_BY_ROLE['admin'],
    'admissions' => DOC_VIEW_BY_ROLE['admissions'],
    'edu' => %w[last_term_report transfer],
    'finance' => [],
    'ops' => [],
    'it' => %w[credentials],
    'lc' => %w[last_term_report exam_certificates picture],
    'rm' => %w[last_term_report exam_certificates picture],
    'exams' => %w[exam_certificates]
  }.freeze

  def initialize(user, record = nil)
    @user = user
    @record = record
    @role = user&.role
  end

  def show?
    return false unless @role

    allowed_types = DOC_VIEW_BY_ROLE[@role] || []
    if record.present?
      allowed_types.include?(record.document_type)
    else
      allowed_types.any?
    end
  end

  def download?
    show?
  end

  def create?(doc_type = nil)
    return false unless @role

    allowed_types = DOC_EDIT_BY_ROLE[@role] || []
    if doc_type.present?
      allowed_types.include?(doc_type.to_s)
    else
      allowed_types.any?
    end
  end

  def destroy?
    return false unless @role && record.present?

    allowed_types = DOC_EDIT_BY_ROLE[@role] || []
    allowed_types.include?(record.document_type)
  end

  def update?
    return false unless @role && record.present?

    allowed_types = DOC_EDIT_BY_ROLE[@role] || []
    allowed_types.include?(record.document_type)
  end

  def visible?(doc_type)
    return false unless @role

    allowed_types = DOC_VIEW_BY_ROLE[@role] || []
    allowed_types.include?(doc_type.to_s)
  end
end
