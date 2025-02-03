class AddOrganisationIdToUserRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :user_roles, :organisation_id, :integer
    add_index :user_roles, :organisation_id
  end
end
