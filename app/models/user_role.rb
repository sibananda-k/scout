class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :organisation
  belongs_to :role

  # Validation to enforce one owner per organization
  # validate :only_one_owner_per_organisation

  private

  # def only_one_owner_per_organisation
  #   if role.name == 'owner' && UserRole.exists?(organisation: organisation, role: role)
  #     errors.add(:role, 'There can only be one owner per organisation.')
  #   end
  # end
end
