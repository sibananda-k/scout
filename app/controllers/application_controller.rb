class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  def after_sign_in_path_for(resource)
    root_path  # This will redirect to the profile page after login
  end

  def after_sign_out_path_for(resource)
    new_user_session_path # Redirect to login screen
  end
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :name, :timezone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :timezone])
    devise_parameter_sanitizer.permit(:invite, keys: [:email, :name, :timezone, :password, :password_confirmation]) # Add this line for invitations

  end  
  
end
