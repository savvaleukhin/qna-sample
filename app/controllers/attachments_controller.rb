class AttachmentsController < ApplicationController
  before_action :load_attachment
  before_action :authenticate_user!

  authorize_resource

  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
