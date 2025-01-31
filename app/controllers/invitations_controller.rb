class InvitationsController < ApplicationController
    before_action :authenticate_user!
    # before_action :check_owner_role, only: [:new, :create]
  
    def new
      @user = User.new
    end

    def create
      # Fetch the organisation of the current user (the owner) based on their 'Owner' role
      organisation_id = current_user.user_roles.find_by(role: Role.find_by(name: 'Owner')).organisation_id
      
      # Find the role to be assigned to the invited user
      role_name = case params[:role]
      when 'fullmember' then 'Full Member'
      when 'limitedfullmember' then 'Limited Full Member'
      when 'admin' then 'Admin'
      else 'Readonly'
      end      
      role = Role.find_by(name: role_name)
    
      # If the role exists, proceed with inviting the user
      if role
        # Create the user with the invitation
        @user = User.invite!(email: params[:email], name: params[:name], password: params[:password], invited_by: current_user)
        # Check if the user is valid and persisted
        if @user.persisted?
          # Create the UserRole for the invited user with the same organisation and the chosen role
          user_role = UserRole.create(user: @user, role: role, organisation_id: organisation_id)
    
          if user_role.persisted?
            flash[:notice] = "Invitation sent successfully to #{@user.email} with the #{role.name} role in your organisation."
            redirect_to new_invitation_path
          else
            # Handle UserRole creation failure
            flash[:alert] = user_role.errors.full_messages.join(", ")
            render :new
          end
        else
          # Handle user creation failure
          flash[:alert] = @user.errors.full_messages.join(", ")
          render :new
        end
      else
        flash[:alert] = "Role not found."
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
    #   unless current_user.owner?
    #     redirect_to root_path, alert: "Only the owner can send invitations."
    #   end
    # end
  end
  