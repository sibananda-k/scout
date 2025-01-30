class Users::SessionsController < Devise::SessionsController
    def create
      byebug
      super do |user|
        byebug
        if user.persisted?
          # Set the session data after user logs in
          if user.organisations.any?
            session[:current_organisation_id] = user.organisations.first.id
            session[:current_role] = user.role_for_organisation(user.organisations.first).name
          end
        end
      end
    end
  end
  