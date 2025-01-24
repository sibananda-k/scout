class CreateOrganisations < ActiveRecord::Migration[7.0]
  def change
    create_table :organisations do |t|
      t.string :organisation_name

      t.timestamps
    end
    add_reference :users, :organisation, null: true, foreign_key: true

  end
end