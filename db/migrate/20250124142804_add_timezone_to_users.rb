class AddTimezoneToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :timezone, :string
    add_column :users, :name, :string

  end
end
