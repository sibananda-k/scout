class ApplicationController < ActionController::Base
  # Override the after_sign_in_path_for method to redirect users to their profile page
  def after_sign_in_path_for(resource)
    profile_path  # This will redirect to the profile page after login
  end
end
