class Users::RegistrationsController < Devise::RegistrationsController
    def create
      super do |user|
        if user.persisted?
          # Handle the new organization creation and assign the 'Owner' role
          if user.new_organisation_name.present?
            if user.save_organisation # your method to create a new organization
              # Get the default role for the organization
              default_role = user.role_for_organisation(user.organisations.last)
              session[:current_organisation_id] = user.organisations.last.id
              session[:current_role] = default_role.name # or whatever role attribute you want
              sign_in(user) unless user_signed_in?
              redirect_to root_path # Replace with the appropriate path
              return
            else
              # If the organisation creation failed, show errors and don't proceed
              render :new
              return
            end
          end
        end
      end
    end
  

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :timezone, :new_organisation_name)
  end
  
end
