module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end

  def sign_in_user_with_question
    before do
      @question = create(:question_with_user)

      @user = @question.user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end