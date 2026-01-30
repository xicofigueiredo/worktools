class CscActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_csc_activity

  def edit
  end

  def update
    params_hash = csc_activity_params.to_h

    # Calculate base credits from hours: hours / 8, max 3.5
    base_credits = nil
    if params_hash['hours'].present?
      hours = params_hash['hours'].to_f
      base_credits = [hours / 8, 3.5].min
    end

    # Calculate final credits: base_credits + extra
    # The credits field stores the final calculated value (base credits + extra)
    if base_credits.present? && params_hash['extra'].present?
      extra = params_hash['extra'].to_f
      final_credits = base_credits + extra
      params_hash['credits'] = final_credits.round(2)
    elsif params_hash['credits'].present?
      # If credits is already calculated (from JS), use it
      params_hash['credits'] = params_hash['credits'].to_f.round(2)
    end

    if @csc_activity.update(params_hash)
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to csc_diploma_path, notice: "Activity updated successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def toggle_hidden
    @csc_activity.update(hidden: !@csc_activity.hidden)
    redirect_to csc_diploma_path
  end

  def purge_attachment
    attachment = @csc_activity.files.find(params[:attachment_id])
    attachment.purge
    redirect_to edit_csc_activity_path(@csc_activity), notice: "File removed successfully."
  end

  private

  def set_csc_activity
    @csc_activity = current_user.csc_diploma.csc_activities.find(params[:id])
  end

  def csc_activity_params
    params.require(:csc_activity).permit(
      :hours, :extra, :credits, :status,
      :full_name, :date_of_submission, :expected_hours,
      :activity_name, :activity_type, :start_date, :end_date,
      :partner, :partner_person, :partner_contact, :confirmation_participation,
      :activity_description, :reflection,
      :unpaid, :not_academic, :time_investment, :evidence,
      :review_date, :reviewed_by, :notes,
      :planing, :effort, :skill, :community,
      tags: [],
      files: []
    )
  end
end
