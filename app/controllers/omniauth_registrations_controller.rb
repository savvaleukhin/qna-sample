class OmniauthRegistrationsController < ApplicationController
  before_action :check_omniauth_info, only: :create
  before_action :check_user_existence, only: :create
  before_action :check_email_valid, only: :create

  skip_authorization_check

  def new
    @user = User.new
  end

  def create
    auth = OmniAuth::AuthHash.new session['devise.omniauth']
    auth.info[:email] = params[:email]
    @user = User.find_for_oauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Successfully signed up with #{auth.provider.capitalize} account."
    else
      flash[:alert] = 'Something went wrong. Try a different login method.'
      redirect_to new_user_session_path
    end
  end

  private

  def check_omniauth_info
    return unless session['devise.omniauth'].blank?
    flash[:alert] = 'Something went wrong. Try a different login method.'
    redirect_to new_user_session_path
  end

  def check_email_valid
    @user = User.new(email: params[:email], allow_blank_password: true)
    return if @user.valid?
    render :new
  end

  def check_user_existence
    return unless User.find_by(email: params[:email])
    flash[:alert] = 'You already have an accaunt for this email.
      You need to log in and add social accounts to you profile.'
    redirect_to new_user_session_path
  end
end
