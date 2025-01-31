class Role < ApplicationRecord
	# belongs_to :organization, optional: true
  has_many :user_roles
  has_many :users, through: :user_roles
  has_many :organisations, through: :user_roles
  validates :name, presence: true, uniqueness: true

  scope :by_name, ->(name) { find_by(name: name) }

end
