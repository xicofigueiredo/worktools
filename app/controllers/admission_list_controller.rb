class AdmissionListController < ApplicationController
  # TODO: Add permissions
  before_action :set_learner_info, only: [:show, :documents, :create_document, :destroy_document]

  def index
    @statuses  = LearnerInfo.distinct.pluck(:status).compact.sort
    @curricula = LearnerInfo.distinct.pluck(:curriculum_course_option).compact.sort
    @grades    = LearnerInfo.distinct.pluck(:grade_year).compact.sort
    @programmes = LearnerInfo.distinct.pluck(:programme).compact.sort

    scope = LearnerInfo.select(:id, :status, :student_number, :full_name, :curriculum_course_option, :grade_year, :programme)

    scope = scope.where(status: params[:status]) if params[:status].present?
    scope = scope.where(curriculum_course_option: params[:curriculum]) if params[:curriculum].present?
    scope = scope.where(grade_year: params[:grade_year]) if params[:grade_year].present?
    scope = scope.where(programme: params[:programme]) if params[:programme].present?

    scope = scope.order(Arel.sql("COALESCE(student_number, 99999999), id"))

    @learner_infos = scope
  end

  def show
    @learner_info = LearnerInfo.includes(:user).find(params[:id])
    excluded = %w[id user_id created_at updated_at]
    @show_columns = LearnerInfo.column_names - excluded
  end

  def documents
    @documents = @learner_info.learner_documents.order(:document_type)
    respond_to do |format|
      format.html { redirect_to admission_path(@learner_info) }
      format.js
    end
  end

  def create_document
    permitted = params.require(:learner_document).permit(:document_type, :description, :file)

    unless LearnerDocument::DOCUMENT_TYPES.include?(permitted[:document_type])
      flash[:alert] = "Invalid document type"
      return redirect_to admission_path(@learner_info)
    end

    # keep one document per type: replace if exists
    existing = @learner_info.learner_documents.find_by(document_type: permitted[:document_type])

    if existing
      if permitted[:file].present?
        existing.file.purge if existing.file.attached?
        existing.file.attach(permitted[:file])
      end
      existing.description = permitted[:description] if permitted.key?(:description)
      saved = existing.save
      @document = existing
    else
      @document = @learner_info.learner_documents.build(
        document_type: permitted[:document_type],
        description: permitted[:description]
      )
      @document.file.attach(permitted[:file]) if permitted[:file].present?
      saved = @document.save
    end

    if saved
      flash[:notice] = "#{@document.human_type} uploaded."
    else
      flash[:alert] = @document.errors.full_messages.to_sentence
    end

    redirect_to admission_path(@learner_info)
  end

  def destroy_document
    @document = @learner_info.learner_documents.find(params[:document_id])
    @document.file.purge if @document.file.attached?
    @document.destroy
    flash[:notice] = "#{@document.human_type} removed."
    redirect_to admission_path(@learner_info)
  end

  private

  def set_learner_info
    @learner_info = LearnerInfo.find(params[:id])
  end
end
