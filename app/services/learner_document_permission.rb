class LearnerDocumentPermission
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    admin? || admissions?
  end

  def download?
    admin? || admissions?
  end

  def create?
    admin? || admissions?
  end

  def destroy?
    admin? || admissions?
  end

  private

  def admin?; user.present? && user.role == 'admin'; end
  def admissions?; user.present? && user.role == 'admissions'; end
end
