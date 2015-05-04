class UsersController < ApplicationController
  before_action :check_omniauth_info, only: :omniauth_registration

  def omniauth_registration
    user = User.where(email: params[:email]).first

    if user
      flash[:alert] = 'You already have an accaunt for this email.
        You need to log in and add social accounts to you profile.'
      redirect_to new_user_session_path
    else
      auth = OpenStruct.new session['devise.omniauth']
      auth.info[:email] = params[:email]
      @user = User.new
      @user = User.find_for_oauth(auth) if @user.email_valid?(params[:email])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        flash[:notice] = "Successfully signed up with #{auth.provider.capitalize} account."
      end
    end
  end

  private

  def check_omniauth_info
    return unless session['devise.omniauth'].blank?
    redirect_to new_user_registration_url
  end
end
