class AttachmentsController < ApplicationController
  before_action :load_attachment
  before_action :authenticate_user!
  before_action :correct_user

  def destroy
    @attachment.destroy
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def correct_user
    unless @attachment.attachmentable.user_id == current_user.id
      render text: 'You do not have permission to view this page.', status: :forbidden
    end
  end
end
