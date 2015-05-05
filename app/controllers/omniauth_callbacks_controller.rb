class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :check_current_user

  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      redirect_to new_user_registration_url
    end
  end

  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      session["devise.omniauth"] = request.env['omniauth.auth'].except('extra')
      redirect_to omniauth_registration_path
    end
  end

  private

  def check_current_user
    return unless current_user
    current_user.create_authorization(request.env['omniauth.auth'])
    flash[:notice] = "Successfully added #{request.env['omniauth.auth'].provider} account."
    redirect_to edit_user_registration_path(current_user)
  end
end
