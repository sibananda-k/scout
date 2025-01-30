class PagesController < ApplicationController
  def index
    @organisations = current_user.organisations if current_user
    @selected_organisation_id = session[:current_organisation_id] || @organisations&.first&.id
  end
  def change_organisation
    selected_organisation = current_user.organisations.find(params[:organisation_id])
    if selected_organisation
      # Set the current organisation and role in the session
      session[:current_organisation_id] = selected_organisation.id
      user_role = current_user.user_roles.find_by(organisation_id: selected_organisation.id)
      session[:current_role] = user_role&.role&.name # Assuming `role` is an associated object

      redirect_to root_path, notice: "Organisation switched successfully"
    else
      redirect_to root_path, alert: "Organisation not found"
    end
  end
end
