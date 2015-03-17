 module ControllerHelper
  def sign_in_user_x(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end
end