class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted?
        # Handle the new organization creation and assign the 'Owner' role
        if user.new_organisation_name.present?
          unless user.save_organisation
            # If the organisation creation failed, render the form with errors
            clean_up_passwords(user)
            set_minimum_password_length
            render :new
            return
          end
          byebug
          # Get the default role for the organization
          default_role = user.role_for_organisation(user.organisations.last)
          session[:current_organisation_id] = user.organisations.last.id
          session[:current_role] = default_role.name # or whatever role attribute you want
        else
          byebug
          user.errors.add(:base, "Organisation name can't be blank.")
          clean_up_passwords(user)
          set_minimum_password_length
          render :new
          return
        end
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :timezone, :new_organisation_name)
  end
end
