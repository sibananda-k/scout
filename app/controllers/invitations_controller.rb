# In your controller (for example, InvitationsController):
class InvitationsController < ApplicationController
    before_action :authenticate_user!
    # before_action :check_owner_role, only: [:new, :create]
  
    def new
    end
  
    def create
      organisation_id = current_user.user_roles.find_by(role: Role.find_by(name: 'Owner')).organisation_id
      user = User.invite!(
        email: params[:email],
        name: params[:name],
        password: params[:password],  
        invited_by: current_user      
        )
    
      if user.persisted? && !user.errors.any?
        if params[:role] == 'fullmember'
          user_role = 'Full Member'
        elsif params[:role] == 'limitedfullmember'
          user_role = 'Limited Full Member'
        elsif params[:role] == 'admin'
          user_role = 'admin'
        else
          user_role = 'Readonly'
        end

        role = Role.find_by(name: user_role)
        if role
          UserRole.create(user: user, role: role, organisation_id: organisation_id)
          flash[:notice] = "Invitation sent successfully to #{user.email} with the #{role.name} role in your organiSation."
          return redirect_to new_invitation_path
        else
          flash[:alert] = "Role not found."
          user.destroy # Rollback user creation if the role is invalid
          render :new
        end
      else
        flash[:alert] = user.errors.full_messages.join(", ")
        render :new
      end
    end
    

    def accept_invitation
      @user = User.find_by(invitation_token: params[:invitation_token])

      if @user && @user.invitation_sent_at > 24.hours.ago
        @user.accept_invitation!
        redirect_to signup_path # Or another page to complete the signup process
      else
        flash[:alert] = "Your invitation has expired or is invalid."
        redirect_to root_path
      end
    end

    def show
      @resource = User.find_by(invitation_token: params[:invitation_token])
      # or if using Devise for invitation:
      @resource = User.invite!(email: params[:email])
    end
  
    private
  
    def invitation_params
      params.require(:invitation).permit(:email, :name, :role)
    end
  
    # def check_owner_role
    #   byebug
    #   unless current_user.owner?
    #     redirect_to root_path, alert: "Only the owner can send invitations."
    #   end
    # end
  end
  