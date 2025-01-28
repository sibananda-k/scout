class UsersController < ApplicationController
  before_action :authenticate_user!

  # Edit profile (name, email, timezone)
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  # Change password page
  def change_password
    @user = current_user
  end

  def update_password
		@user = current_user
		if @user.update_with_password(password_params)
			redirect_to profile_path, notice: 'Password updated successfully.'
		else
			render :change_password
		end
	end

  private

  # Permit user parameters for profile update
  def user_params
    params.require(:user).permit(:name, :email, :timezone)
  end

  # Permit password parameters for password update
  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
