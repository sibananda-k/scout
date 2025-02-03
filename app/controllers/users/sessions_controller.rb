class Users::SessionsController < Devise::SessionsController
  def create
    super do |user|
      if user.persisted?
        # Check if the user already has an organisation associated
        if user.organisations.present?
          # Assuming the first organisation is the default one; you can change this logic
          session[:current_organisation_id] = user.organisations.first.id
          default_role = user.role_for_organisation(user.organisations.first)
          session[:current_role] = default_role.name # or whatever role attribute you want
        end
      end
    end
  end
end
