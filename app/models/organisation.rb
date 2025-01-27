class Organisation < ApplicationRecord
  has_many :users
  # has_many :user_roles
  # has_many :roles, through: :user_roles
  validates :organisation_name, presence: true, uniqueness: true
end
