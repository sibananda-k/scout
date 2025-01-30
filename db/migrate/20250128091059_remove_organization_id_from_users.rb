class RemoveOrganizationIdFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :organisation_id, :integer
  end
end
