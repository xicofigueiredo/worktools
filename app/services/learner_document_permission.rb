class LearnerDocumentPermission
  attr_reader :user, :record

  EDU_VISIBLE_DOCS = %w[special_needs medical_form last_term_report].freeze
  EDU_EDITABLE_DOCS = %w[last_term_report].freeze

  def initialize(user, record = nil)
    @user = user
    @record = record
  end

  def show?
    return true if admin? || admissions?
    return EDU_VISIBLE_DOCS.include?(record.document_type) if edu? && record.present?
    false
  end

  def download?
    show?
  end

  def create?(doc_type = nil)
    return true if admin? || admissions?
    return EDU_EDITABLE_DOCS.include?(doc_type.to_s) if edu? && doc_type.present?
    false
  end

  def destroy?
    return true if admin? || admissions?
    return EDU_EDITABLE_DOCS.include?(record.document_type) if edu? && record.present?
    false
  end

  private

  def admin?; user.present? && user.role == 'admin'; end
  def admissions?; user.present? && user.role == 'admissions'; end
  def edu?; user.present? && user.role == 'edu'; end
end
