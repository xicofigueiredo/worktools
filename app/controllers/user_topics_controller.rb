class UserTopicsController < ApplicationController
  def update_done
    @user_topic = UserTopic.find(params[:id])
    @user_topic.update(done: params[:done])

    respond_to do |format|
      if @user_topic.save
        format.turbo_stream
      else
        format.json { render json: @user_topic.errors, status: :unprocessable_entity }
      end
    end
  end
end
