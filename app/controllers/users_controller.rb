class UsersController < ApplicationController
  before_action :authenticate_user!  # Ensures the user is logged in

  # Edit action to show the user's profile
  def edit
    @user = current_user
  end

  # Update action to handle form submission
  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)  # Add other fields here
  end
end
