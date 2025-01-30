class Organisation < ApplicationRecord
  has_many :user_roles
  has_many :users, through: :user_roles
  has_many :roles, through: :user_roles
  # Validation to enforce one owner per organization
  validates :organisation_name, presence: true, uniqueness: { case_sensitive: false }
  validates :organisation_name, length: { minimum: 3, maximum: 50 }


end
