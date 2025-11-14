class LearnerInfoLogPermission
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    admin? || admissions?
  end

  # whether the user can view full changed_data / JSON diffs
  def view_changed_data?
    admin? || admissions?
  end

  private

  def admin?; user.present? && user.role == 'admin'; end
  def admissions?; user.present? && user.role == 'admissions'; end
end
