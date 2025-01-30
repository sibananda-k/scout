class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :invitable

  # has_secure_password
  attr_accessor :want_to_create_organisation, :new_organisation_name

  has_many :user_roles
  has_many :organisations, through: :user_roles
  has_many :roles, through: :user_roles
  belongs_to :invited_by, class_name: "User", optional: true

  validates :name, presence: true
  validates :timezone, presence: true

  def role_for_organisation(organisation)
    user_role = user_roles.find_by(organisation: organisation)
    user_role&.role
  end

  def save_organisation
    if new_organisation_name.blank?
      errors.add(:base, "Organisation name can't be blank.")
      return false
    end
  
    if Organisation.exists?(organisation_name: new_organisation_name)
      errors.add(:base, "Organisation name already exists. Please choose a different name.")
      return false
    end
    byebug
  
    organisation = Organisation.new(organisation_name: new_organisation_name)
  
    if organisation.save
      owner_role = Role.find_by(name: "Owner")
      UserRole.create(user: self, organisation: organisation, role: owner_role)
      return true
    else
      organisation.errors.full_messages.each do |message|
        errors.add(:base, message)
      end
      return false
    end
  end
  
  
  
    
end
